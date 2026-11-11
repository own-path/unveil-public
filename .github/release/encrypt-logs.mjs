// Encrypts a job's private build logs for the release maintainer only:
// AES-256-GCM with a fresh key, the key wrapped with RSA-OAEP (SHA-256) to the
// public key in logs-key.pub.pem. decrypt-logs.mjs in the source repository
// reverses it with the private key kept off GitHub.
//   node encrypt-logs.mjs <public key pem> <input> <output>
import { constants, createCipheriv, publicEncrypt, randomBytes } from 'node:crypto';
import { readFileSync, writeFileSync } from 'node:fs';

const [pem, input, output] = process.argv.slice(2);
if (!pem || !input || !output) {
  console.error('usage: encrypt-logs.mjs <public key pem> <input> <output>');
  process.exit(2);
}
const key = randomBytes(32);
const iv = randomBytes(12);
const cipher = createCipheriv('aes-256-gcm', key, iv);
const body = Buffer.concat([cipher.update(readFileSync(input)), cipher.final()]);
const wrapped = publicEncrypt(
  { key: readFileSync(pem), padding: constants.RSA_PKCS1_OAEP_PADDING, oaepHash: 'sha256' },
  key,
);
writeFileSync(output, JSON.stringify({
  format: 'unveil-release-logs/1',
  key: wrapped.toString('base64'),
  iv: iv.toString('base64'),
  tag: cipher.getAuthTag().toString('base64'),
  body: body.toString('base64'),
}));
