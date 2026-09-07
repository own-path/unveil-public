```
 ███╗██╗   ██╗███╗   ██╗███╗██╗   ██╗███████╗██╗██╗
 ██╔╝██║   ██║████╗  ██║╚██║██║   ██║██╔════╝██║██║
 ██║ ██║   ██║██╔██╗ ██║ ██║██║   ██║█████╗  ██║██║
 ██║ ██║   ██║██║╚██╗██║ ██║╚██╗ ██╔╝██╔══╝  ██║██║
 ███╗╚██████╔╝██║ ╚████║███║ ╚████╔╝ ███████╗██║███████╗
 ╚══╝ ╚═════╝ ╚═╝  ╚═══╝╚══╝ ╚═══╝  ╚══════╝╚═╝╚══════╝
```

**An autonomous research terminal for mechanistic interpretability.**

[un]veil loads transformer models, runs experiments on their internals, and writes up the results — with minimal human involvement.

---

## Install

One-line install for macOS and Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/own-path/unveil-public/main/install.sh | bash
```

The installer picks the right archive for your platform, verifies the signature (if `cosign` is on your PATH), extracts to `~/.local/share/unveil/`, and symlinks the `unveil` binary into `~/.local/bin/`.

Alternatively, download the archive manually from [Releases](https://github.com/own-path/unveil-public/releases) and run the bundled `install.sh`.

### Platforms

| Platform                          | Archive                              |
|-----------------------------------|--------------------------------------|
| macOS Apple Silicon (M1–M4)       | `unveil-vX.Y.Z-darwin-arm64.tar.gz`  |
| macOS Intel                       | `unveil-vX.Y.Z-darwin-x64.tar.gz`    |
| Linux x86_64                      | `unveil-vX.Y.Z-linux-x64.tar.gz`     |
| Linux arm64                       | `unveil-vX.Y.Z-linux-arm64.tar.gz`   |

### Homebrew (macOS)

```bash
brew install own-path/unveil/unveil
```

## Requirements

- **API key** for at least one LLM provider: Anthropic, OpenAI, Google, or Cerebras.
- **Python 3.10+** — required only if you use the machine-learning tools (model loading, probes, activation analysis). The base terminal runs without it.
- **RAM** — 8 GB minimum; 16 GB+ recommended for loading larger transformer models.
- **Network** — outbound HTTPS to your chosen provider and (optionally) HuggingFace for model downloads.

### Optional: ML toolchain

The ML tools (probes, activation patching, attention analysis, SAE decomposition) depend on PyTorch and TransformerLens. Install them once:

```bash
unveil setup ml
```

This creates an isolated Python environment under `~/.local/share/unveil/.venv`. Without this step, ML commands will tell you what to run and then exit cleanly — they won't crash.

## Quick start

```bash
# Launch
unveil

# Pick a provider (one-time)
/set-provider anthropic/claude-opus-4-7

# Pose a research question and let it run
/research does Llama-3 share positional subspaces across English and French?
```

That one command is the full lifecycle: it seeds the research plan, iterates experiments on its own, clusters findings, grades evidence, and writes an ArXiv-ready paper when it's confident it has something to say. Hit `Ctrl+C` any time to stop.

For one-shot use without the autonomous loop, drop into `general` or `kaggle` mode:

```bash
/set-mode general         # coding assistant
/set-mode kaggle          # competition workflows
```

## Modes

| Mode      | For                                                    |
|-----------|--------------------------------------------------------|
| `research`| Mechanistic interpretability experiments & papers.     |
| `general` | Programming, code review, refactoring, PRs.            |
| `kaggle`  | Feature engineering, cross-validation, ensembles.      |

## Remote access (optional)

[un]veil can stay running in the background and be steered from chat. This is useful for long autonomous runs — start the work at your desk, check in from your phone.

Supported platforms: **Telegram**, **Discord**, **Slack**.

1. Start the background service:

   ```bash
   unveil serve
   ```

2. Drop your bot token into the appropriate file, e.g. for Telegram:

   ```bash
   mkdir -p ~/.unveil/adapters
   echo 'YOUR_BOT_TOKEN' > ~/.unveil/adapters/telegram.token
   chmod 600 ~/.unveil/adapters/telegram.token
   ```

3. Authorise yourself in `~/.unveil/gateway/users.toml`:

   ```toml
   [[user]]
   platform = "telegram"
   id       = "123456789"     # your Telegram numeric user id
   name     = "you"
   ```

4. Launch the adapter:

   ```bash
   unveil adapter telegram
   ```

5. Message the bot:

   ```
   status                              # summary of the current run
   @ml-project focus on layer 12       # steer a specific session by name
   runs                                # list all active runs
   stop                                # stop the current run
   ```

Named sessions (the `@ml-project` form) line up with the session names you see in the TUI — start a session in one place, address it by name from anywhere.

Remote access never binds a public port. Chat adapters connect outbound to their platform; the local gateway is on a Unix socket (plus an optional loopback-only TCP port gated by a bearer token). For off-LAN access, put the host on Tailscale or SSH-tunnel — not a public IP.

## Usage tips

- **`/wizard`** — full setup check with copy-paste fix instructions for anything missing.
- **`/doctor`** — quick health probe (provider reachable, API key valid, ML env present).
- **`/help`** — complete command reference, grouped by topic.
- **`/set-theme`** — 20+ themes. Try `catppuccin`, `dracula`, `nord`, `tokyo-night`, `rose-pine`.
- **Mid-run steering** — while the agent is thinking, just start typing. Your text is injected as guidance at the next safe boundary.

## Uninstall

```bash
rm -f ~/.local/bin/unveil
rm -rf ~/.local/share/unveil
rm -rf ~/.unveil          # config, sessions, tokens — keep this if you plan to reinstall
```

## Support

- **Issues / feedback:** open an issue on this repo.
- **Security concerns:** email security@4thwall.dev — please do not file a public issue.

## License

Proprietary — 4thWall Labs. All rights reserved.
