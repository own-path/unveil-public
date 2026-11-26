<div align="center">
  <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/readme/header-dark.png"><img src="docs/images/readme/header.png" alt="Unveil, a research workspace built on Deep Agents. See inside intelligence. Beside it, a provenance trail: a question, the hypothesis it raised, the run that tested it, and the evidence that supports it" width="100%"></picture>
  <p>
    <a href="https://github.com/own-path/unveil-public/releases/latest"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/readme/badge-desktop-dark.png"><img src="docs/images/readme/badge-desktop.png" alt="Desktop 0.1.45" height="28"></picture></a>
    <a href="#download"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/readme/badge-runs-on-dark.png"><img src="docs/images/readme/badge-runs-on.png" alt="Runs on macOS, Linux and Windows" height="28"></picture></a>
    <a href="https://github.com/langchain-ai/deepagents"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/readme/badge-built-on-dark.png"><img src="docs/images/readme/badge-built-on.png" alt="Built on Deep Agents" height="28"></picture></a>
    <a href="https://tauri.app"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/readme/badge-app-dark.png"><img src="docs/images/readme/badge-app.png" alt="Tauri 2 app" height="28"></picture></a>
  </p>
  <p>
    <b><a href="#download">Download →</a></b> ·
    <a href="#get-started">Get started</a> ·
    <a href="#connect-your-research-stack">Integrations</a> ·
    <a href="#questions">Questions</a>
  </p>
</div>

**Unveil is where a model-behavior question turns into evidence you can audit.** Ask it like you'd
ask a colleague. An agent reads the literature, states a hypothesis, commits a plan, runs the
experiment on your machine or your GPUs, and keeps everything as a typed record, so any claim can be
traced back through its runs and plans to the question that asked for it.

<p align="center">
  <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/readme/conversation-dark.png"><img src="docs/images/readme/conversation.png" alt="A research conversation in Unveil: the answer cites the record, and the cards beside it show the evidence, the experiment running and recent findings" width="100%"></picture>
</p>

This repository hosts Unveil's public downloads. The source code is not published here.

## Download

Get the installer for your platform from the [latest release](https://github.com/own-path/unveil-public/releases/latest).

| Platform | Download | Install |
| --- | --- | --- |
| macOS, Apple Silicon | [Unveil-macos-arm64.dmg](https://github.com/own-path/unveil-public/releases/latest/download/Unveil-macos-arm64.dmg) | Open the disk image and drag Unveil to Applications. |
| macOS, Intel | [Unveil-macos-x64.dmg](https://github.com/own-path/unveil-public/releases/latest/download/Unveil-macos-x64.dmg) | Open the disk image and drag Unveil to Applications. |
| Linux x86_64 (Debian, Ubuntu) | [Unveil-linux-x64.deb](https://github.com/own-path/unveil-public/releases/latest/download/Unveil-linux-x64.deb) | `sudo apt install ./Unveil-linux-x64.deb` |
| Linux x86_64 (AppImage) | [Unveil-linux-x64.AppImage](https://github.com/own-path/unveil-public/releases/latest/download/Unveil-linux-x64.AppImage) | `chmod +x Unveil-linux-x64.AppImage`, then run it. |
| Windows x86_64 | [Unveil-windows-x64-setup.exe](https://github.com/own-path/unveil-public/releases/latest/download/Unveil-windows-x64-setup.exe) | Run the installer. It installs for the current user. |

[SHA256SUMS.txt](https://github.com/own-path/unveil-public/releases/latest/download/SHA256SUMS.txt)
lists a checksum for every file. To check a download:

```bash
shasum -a 256 -c SHA256SUMS.txt --ignore-missing   # macOS
sha256sum -c SHA256SUMS.txt --ignore-missing       # Linux
```

**The first launch may need your approval.** The macOS app is not yet notarized and the Windows
installer is not yet code-signed, so the system warns you once:

- **macOS:** if Unveil "can't be opened", open System Settings → Privacy & Security, scroll to the
  message about Unveil and choose **Open Anyway**.
- **Windows:** if SmartScreen stops the installer, choose **More info**, then **Run anyway**.
- **Linux:** the app needs the WebKitGTK 4.1 runtime and a desktop session. The AppImage may also
  need FUSE support from your distribution.

**Updates come to you.** Unveil checks this repository's releases for new versions and shows when
one is ready; you choose when to install it. Every update package is signed, and the app checks the
signature against the key built into it before installing.

## Connect your research stack

Use the model providers, agent subscriptions and compute you already have.

<table align="center">
  <tr>
    <td align="center" width="25%"><a href="https://openai.com/"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/integrations/openai-dark.svg"><img src="docs/images/integrations/openai.svg" width="30" height="30" alt="OpenAI / ChatGPT"></picture><br><sub>OpenAI / ChatGPT</sub></a></td>
    <td align="center" width="25%"><a href="https://claude.ai/"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/integrations/claude-dark.svg"><img src="docs/images/integrations/claude.svg" width="30" height="30" alt="Claude"></picture><br><sub>Claude</sub></a></td>
    <td align="center" width="25%"><a href="https://gemini.google.com/"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/integrations/gemini-dark.svg"><img src="docs/images/integrations/gemini.svg" width="30" height="30" alt="Gemini"></picture><br><sub>Gemini</sub></a></td>
    <td align="center" width="25%"><a href="https://openrouter.ai/"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/integrations/openrouter-dark.svg"><img src="docs/images/integrations/openrouter.svg" width="30" height="30" alt="OpenRouter"></picture><br><sub>OpenRouter</sub></a></td>
  </tr>
  <tr>
    <td align="center" width="25%"><a href="https://opencode.ai/"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/integrations/opencode-dark.svg"><img src="docs/images/integrations/opencode.svg" width="30" height="30" alt="OpenCode"></picture><br><sub>OpenCode</sub></a></td>
    <td align="center" width="25%"><a href="https://cursor.com/"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/integrations/cursor-dark.svg"><img src="docs/images/integrations/cursor.svg" width="30" height="30" alt="Cursor"></picture><br><sub>Cursor</sub></a></td>
    <td align="center" width="25%"><a href="https://modal.com/"><img src="docs/images/integrations/modal.svg" width="52" height="30" alt="Modal"><br><sub>Modal</sub></a></td>
    <td align="center" width="25%"><a href="https://huggingface.co/"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/integrations/huggingface-dark.svg"><img src="docs/images/integrations/huggingface.svg" width="30" height="30" alt="Hugging Face"></picture><br><sub>Hugging Face</sub></a></td>
  </tr>
</table>

**Models:** OpenAI, Claude, Gemini, OpenRouter, Groq, Cerebras and Hugging Face, plus local
servers such as Ollama, LM Studio and oMLX.

**Agent sessions:** Codex, Claude Code, OpenCode, Cursor and Antigravity. Foundry can use a
ChatGPT or Claude subscription lead with bounded free OpenCode workers.

**Compute:** this machine, SSH, Slurm, Kubernetes, Ray, Modal, Hugging Face Jobs, RunPod and Tinker.

Connect models and agent sign-ins in Settings → Providers, and compute in Settings → Connections.

## Get started

1. **Open Unveil.** It starts its own research harness, so there's nothing else to install or
   run. Your research is kept in `~/Unveil` (your home folder) until you open another folder. A
   short welcome walks you through the next two steps and shows a 30-second sample study.
2. **Give it a model.** Sign in to an agent CLI you already use (Claude Code, Codex, Cursor or
   OpenCode; Settings shows which ones it found and how to sign in), add an API key for a model
   provider, or connect a local open-weights server such as LM Studio or Ollama. Keys are stored in
   your operating system's keychain.
3. **Ask a question.** Start small and checkable, for example *"Is 2^61 − 1 prime?"*, and look at
   the record it leaves.

Experiments on models run in Python on your machine. They need Python 3.10 or newer (3.11
recommended) and optional ML packages.

<table>
  <tr>
    <td width="50%"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/unveil-welcome-dark.jpg"><img src="docs/images/unveil-welcome.jpg" alt="The welcome screen: the Unveil mark, “See inside intelligence.” and a Get started button over a quiet grid" width="100%"></picture></td>
    <td width="50%"><picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/unveil-home-dark.jpg"><img src="docs/images/unveil-home.jpg" alt="New research: the Unveil mark and the composer over a quiet grid, with starting points and a calendar of saved research activity below" width="100%"></picture></td>
  </tr>
</table>

## What it does

- **A record, not a chat log.** Questions, hypotheses, plans, runs, evidence and claims are kept as
  linked records on your disk. Refer to any of them in the conversation, as `@H2` or `@EXP4`.
- **Experiments that leave evidence.** Each run gets a fresh interpreter, its own directory and seed,
  and records its metrics, per-example scores, files and environment.
- **The plan comes first.** A plan is committed before its run, and a run can't be edited after.
  "It improved" is answered with an interval, not a single number.
- **Long work doesn't block you.** Runs survive the app quitting, background helpers report back
  when they finish, and a campaign can keep working one question for hours or days.
- **Your models, your tools.** Model APIs, a ChatGPT plan, local models or an agent CLI you already
  use. Connect MCP servers to give the agent your own tools and data.
- **Research together.** Team chats put your teammates and Unveil in one conversation. Replies
  quote and link back to what they answer, and Unveil can read along and join in when it has
  something to add, no @ needed.
- **Keep it safe, share it whole.** A daily backup of your research record, restore from
  Settings, and export of a whole research question as a replication package.
- **Cloud compute beside the chat.** Follow remote-run progress and logs in a compact context card,
  with a separate compute budget, estimated usage and projected cost. Details stay within the card;
  unknown prices and forecasts stay unknown.

**Follow the evidence.** Every record is linked to what it rests on. Select one and its whole trail
lights up, back to the question and forward to the findings.

<p align="center">
  <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/unveil-graph-dark.jpg"><img src="docs/images/unveil-graph.jpg" alt="The provenance graph: a question, a paper, a hypothesis, a plan, two runs and two findings, linked left to right" width="100%"></picture>
</p>

**Research together.** Your teammates and Unveil in one conversation, with the same history for
everyone.

<p align="center">
  <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/readme/team-chat-dark.png"><img src="docs/images/readme/team-chat.png" alt="A team chat: three researchers and Unveil discuss an ablation; Unveil reports the result with a confidence interval and links it to the record" width="100%"></picture>
</p>

<table>
  <tr>
    <td width="50%">
      <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/unveil-library-dark.jpg"><img src="docs/images/unveil-library.jpg" alt="The Library: hypotheses, plans, runs, evidence and papers with their status" width="100%"></picture>
      <p><b>The Library.</b> Every record, searchable and filterable by kind: hypotheses, plans,
      runs, evidence and papers. Something still needing review says so.</p>
    </td>
    <td width="50%">
      <picture><source media="(prefers-color-scheme: dark)" srcset="docs/images/unveil-agents-dark.jpg"><img src="docs/images/unveil-agents.jpg" alt="Customize: the agent CLIs Unveil found on this machine and how to install the rest" width="100%"></picture>
      <p><b>Agents and tools.</b> The agent CLIs Unveil found on this machine, whether they are
      ready, and how to install the rest.</p>
    </td>
  </tr>
</table>

<p align="center"><sub>Screenshots use the app's sample workspace and sample people, so their numbers are illustrative.<br>They follow your light or dark setting.</sub></p>

## Questions

**What does it cost?** Unveil doesn't sell tokens. You pay your model provider, use a plan or CLI
you already have, or run local models for free. The Usage page shows recorded model spend, with
unknown prices left unpriced. Cloud jobs are billed separately by the compute provider. The compute
card currently shows partial GPU-only estimates and a planning budget, not an enforced spending cap.

**Does my research leave my machine?** The record stays on your disk. What you ask goes to the
model provider you chose. Team chat messages go to the team service so your teammates can read them.

**Do I need a GPU?** No. Small models run locally. For bigger ones, point Unveil at your GPU
machines.

**Does it work on Windows?** The app runs on Windows with the agent CLI providers. Local research
experiments currently need macOS or Linux.

**Why do I see "Veil" in places?** It's the project's earlier name.

## Terminal app (2026.4)

The April 2026 terminal release is still available for macOS and Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/own-path/unveil-public/main/install.sh | sh
```

It installs the newest terminal release (currently
[v2026.4.25](https://github.com/own-path/unveil-public/releases/tag/v2026.4.25)) into
`~/.local/share/unveil` and links `unveil` into `~/.local/bin`, without `sudo`. Remove it with
`rm -rf ~/.local/bin/unveil ~/.local/share/unveil`. The desktop app above is where new work happens.

## Support

- **Problems and feedback:** open an issue in this repository.
- **Security reports:** email security@4thwall.dev rather than filing a public issue.

## License

Proprietary, 4thWall Labs. All rights reserved. The downloads are provided for your own use; no
redistribution rights are granted. See [LICENSE](LICENSE).
