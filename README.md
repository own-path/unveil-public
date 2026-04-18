```
 ███╗██╗   ██╗███╗   ██╗███╗██╗   ██╗███████╗██╗██╗
 ██╔╝██║   ██║████╗  ██║╚██║██║   ██║██╔════╝██║██║
 ██║ ██║   ██║██╔██╗ ██║ ██║██║   ██║█████╗  ██║██║
 ██║ ██║   ██║██║╚██╗██║ ██║╚██╗ ██╔╝██╔══╝  ██║██║
 ███╗╚██████╔╝██║ ╚████║███║ ╚████╔╝ ███████╗██║███████╗
 ╚══╝ ╚═════╝ ╚═╝  ╚═══╝╚══╝ ╚═══╝  ╚══════╝╚═╝╚══════╝
```

**Lifting the veil on multilingual model internals.**

[un]veil is an autonomous AI-powered research terminal for mechanistic interpretability. It loads transformer models locally, probes their internals, runs experiments, and writes papers — with minimal human involvement.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/own-path/unveil-public/main/install.sh | bash
```

Or download the archive for your platform from [Releases](https://github.com/own-path/unveil-public/releases) and run `install.sh` manually.

### Platforms

| Platform | Archive |
|----------|---------|
| macOS Apple Silicon (M1/M2/M3/M4) | `unveil-vX.Y.Z-darwin-arm64.tar.gz` |
| macOS Intel | `unveil-vX.Y.Z-darwin-x64.tar.gz` |
| Linux x86_64 | `unveil-vX.Y.Z-linux-x64.tar.gz` |
| Linux arm64 | `unveil-vX.Y.Z-linux-arm64.tar.gz` |

### Requirements

- An API key for at least one provider (Anthropic, OpenAI, or Google)
- Python 3.10+ for ML features (probes, activations, SAE)
- 8GB+ RAM recommended (16GB+ for larger models)

## What it does

[un]veil is a terminal-native research assistant that combines LLM reasoning with direct access to model internals:

**Research mode** — Run mechanistic interpretability experiments autonomously. The agent loads models, probes residual streams, patches activations, analyses attention heads, and logs findings — following a structured experimental protocol with causal evidence requirements (L4+).

**Programming mode** — A full-featured coding assistant with file editing, code search, git integration, AI-powered commits and PR descriptions, security reviews, and refactoring suggestions.

**Kaggle mode** — Competition-oriented workflows with feature engineering, cross-validation, ensemble strategies, and leaderboard tracking.

### Key features

- **Autonomous research** — Run N experiments without human input. Background mode lets you keep working while experiments stream results live.
- **Web search** — Grounded in current literature. 3-tier fallback: Anthropic native → Tavily → DuckDuckGo. ArXiv search for papers.
- **Hardware-aware model loading** — Detects your RAM/VRAM and loads compatible models automatically.
- **Multi-provider** — Anthropic, OpenAI, Google, Cerebras, or your own local/Tailscale server.
- **20+ themes** — Catppuccin, Dracula, Nord, Tokyo Night, Gruvbox, Rose Pine, and more.
- **Session persistence** — Save, resume, and fork research sessions.
- **Paper generation** — Export findings as ArXiv-ready LaTeX.
- **Mid-run steering** — Inject instructions while the agent is thinking.
- **Triggers** — `/cron` and `/watch` fire the agent automatically on a schedule or when a file changes.
- **Skills** — Installable slash-command extensions. Prompt-based (`~/.unveil/skills/*.md`) or code-based (directory with `skill.json`).
- **MCP server** — Expose all [un]veil tools to any MCP-compatible client (`veil-mcp` binary, stdio transport).
- **Setup wizard** — `/wizard` checks every dependency and prints exact fix instructions.

## Usage

```bash
# Start [un]veil
unveil

# Set your provider
/set-provider anthropic/claude-sonnet-4-20250514

# Load a model for interpretability research
/load bigscience/bloom-560m

# Run a probe
/probe layer=4

# Run autonomous experiments
/run-autonomous 10

# Get help
/help
```

## How it works

[un]veil combines three layers:

1. **Agent loop** — An LLM-driven reasoning loop with parallel tool execution, sub-agent spawning, and structured experiment tracking.
2. **Rust daemons** — Native binaries for session persistence (SQLite), process management, and Python IPC.
3. **Python ML runtime** — TransformerLens-based toolkit for probes, activation patching, sparse autoencoders, and logit lens.

The agent follows a rigorous experimental protocol:
```
Observe → Measure → Generalize → Intervene → Behavioral test → Rule out alternatives
```
Findings require L4+ causal evidence. No hand-waving.

## Commands

| Command | Description |
|---------|-------------|
| `/load` | Load a HuggingFace model |
| `/probe` | Linear probe on residual stream |
| `/patch` | Patch activations across languages |
| `/heads` | Attention head patterns |
| `/circuits` | Path patching / circuit analysis |
| `/sae` | Sparse autoencoder decomposition |
| `/sim` | Cross-lingual similarity matrix |
| `/logit-lens` | Unembed residual stream per layer |
| `/run-autonomous` | Run N experiments autonomously |
| `/run-research` | Full autonomous research run |
| `/write-paper` | Generate ArXiv-ready paper |
| `/commit` | AI commit message + git commit |
| `/review` | AI code review |
| `/cron` | Fire agent on a repeating interval (e.g. `30m`, `1h`) |
| `/watch` | Fire agent when a file changes |
| `/triggers` | List active triggers |
| `/daemon` | Install / manage background Rust daemons |
| `/wizard` | Full setup check with fix instructions |
| `/skills` | List / install / invoke skill extensions |
| `/doctor` | Health check |
| `/help` | Full command reference |

## Contributing

[un]veil is not open source. This repository provides release binaries and documentation. If you're interested in contributing or have feedback, open an issue.

## License

Proprietary — 4thWall Labs. All rights reserved.
