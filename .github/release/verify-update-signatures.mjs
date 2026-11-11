// Checks every updater signature in latest.json against the public key the app
// ships with, so a release can never announce a package the app would reject.
//   node verify-update-signatures.mjs <release dir> <base64 TAURI_UPDATER_PUBKEY> <expected version> <expected download base URL>
import { createHash, createPublicKey, verify } from 'node:crypto';
import { readFileSync } from 'node:fs';
import { basename, join } from 'node:path';

const [dir, pubkeyB64, version, base] = process.argv.slice(2);
if (!dir || !pubkeyB64 || !version || !base) {
  console.error('usage: verify-update-signatures.mjs <dir> <pubkey> <version> <base url>');
  process.exit(2);
}
const lines = text => text.split('\n').map(line => line.trim()).filter(Boolean);
const keyLine = lines(Buffer.from(pubkeyB64, 'base64').toString('utf8')).find(line => !line.startsWith('untrusted comment:'));
const raw = Buffer.from(keyLine, 'base64');
if (raw.length !== 42 || raw.subarray(0, 2).toString() !== 'Ed') throw new Error('Unexpected minisign public key format');
const keyId = raw.subarray(2, 10);
const publicKey = createPublicKey({ key: Buffer.concat([Buffer.from('302a300506032b6570032100', 'hex'), raw.subarray(10)]), format: 'der', type: 'spki' });

const feed = JSON.parse(readFileSync(join(dir, 'latest.json'), 'utf8'));
if (feed.version !== version) throw new Error(`latest.json version ${feed.version} != ${version}`);
const expected = ['darwin-aarch64', 'darwin-x86_64', 'linux-x86_64', 'windows-x86_64'];
const platforms = Object.keys(feed.platforms ?? {}).sort();
if (platforms.join() !== expected.join()) throw new Error(`latest.json platforms: ${platforms.join(', ')}`);

for (const platform of expected) {
  const { url, signature } = feed.platforms[platform];
  const name = basename(new URL(url).pathname);
  if (url !== `${base}/${name}`) throw new Error(`${platform}: URL ${url} is not under ${base}`);
  const [, sigLine, trustedLine, globalLine] = lines(Buffer.from(signature, 'base64').toString('utf8'));
  const sig = Buffer.from(sigLine, 'base64');
  const algorithm = sig.subarray(0, 2).toString();
  if (sig.length !== 74 || !['Ed', 'ED'].includes(algorithm)) throw new Error(`${platform}: bad signature format`);
  if (!sig.subarray(2, 10).equals(keyId)) throw new Error(`${platform}: signed by another key`);
  const file = readFileSync(join(dir, name));
  const message = algorithm === 'ED' ? createHash('blake2b512').update(file).digest() : file;
  if (!verify(null, message, publicKey, sig.subarray(10))) throw new Error(`${platform}: signature does not match ${name}`);
  if (!trustedLine.startsWith('trusted comment: ')) throw new Error(`${platform}: missing trusted comment`);
  const trusted = Buffer.from(trustedLine.slice('trusted comment: '.length));
  if (!verify(null, Buffer.concat([sig.subarray(10), trusted]), publicKey, Buffer.from(globalLine, 'base64'))) {
    throw new Error(`${platform}: trusted comment signature is invalid`);
  }
  console.log(`ok ${platform}: ${name}`);
}
console.log(`All ${expected.length} update packages verify against key ${Buffer.from(keyId).reverse().toString('hex').toUpperCase()}`);
