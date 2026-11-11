<h1 align="center">agents</h1>

<p align="center">
  <b>Every running Claude Code session and its subagents, as one live tree.</b><br>
  Which Claude is working, which one is idle, and which one is waiting for you.
</p>

<p align="center">
  <img alt="macOS and Linux" src="https://img.shields.io/badge/macOS%20%C2%B7%20Linux-1f1e1d?logo=apple&logoColor=white">
  <img alt="Python 3.9 or later" src="https://img.shields.io/badge/Python-3.9%2B-1f1e1d">
  <img alt="Version 1.0.0" src="https://img.shields.io/badge/version-1.0.0-d97757">
</p>

<p align="center">
  <img src="docs/agents.svg?v=1.0.0" width="820" alt="The agents view: two groups of Claude Code sessions, each session with its state, folder and time, and the running subagents as a tree under it">
</p>

Claude Code runs in many places at once: terminals, the desktop app, worktrees, background agents that start agents of their own. `agents` puts all of them on one screen. Sessions that wait for you come first.

## Install

**Native install**

```sh
curl -fsSL https://raw.githubusercontent.com/Berrysekk/Agents-cli/main/install.sh | sh
```

**Homebrew**

```sh
brew tap berrysekk/agents-cli https://github.com/Berrysekk/Agents-cli
brew trust berrysekk/agents-cli
brew install agents-cli
```

It is one Python file without dependencies; Python 3.9 or later is all it needs.

## Use

```sh
agents
```

opens the view in the picture and refreshes it every 2 seconds. **q** quits.

| Command | What it does |
|---|---|
| `agents` | The live view |
| `agents --once` | One frame, also what you get in a pipe |
| `agents --json` | The same data for scripts |
| `agents config` | The groups in effect, as the JSON the config file takes |
| `agents update` | Installs the latest version |
| `agents version` · `help` | The version, all commands |

## What it shows

| | |
|---|---|
| <b>● waiting</b> | Claude asked you something or needs a permission. The reason is on the right. |
| <b>● working</b> | Claude is busy |
| <b>● idle</b> | The session is open and has nothing to do |
| `├─ ●` | A running subagent, with its type. Subagents started by a subagent sit one level deeper. |

The middle column is the folder the session works in; a worktree shows as `repo ⎇ worktree`. The time on the right is how long the session has been in its state, or how long a subagent has been running.

## Groups

Every Claude config directory is a group. Without a config file, `agents` finds them itself: `~/.claude`, every `~/.claude-*` (the usual way to keep a second account: `CLAUDE_CONFIG_DIR=~/.claude-work claude`) and `$CLAUDE_CONFIG_DIR`.

To name, reorder or drop groups, save what `agents config` prints as `~/.config/agents/config.json` and edit it:

```json
{
  "groups": [
    { "name": "Work", "dir": "~/.claude-work" },
    { "name": "Personal", "dir": "~/.claude" }
  ]
}
```

## How it works

Claude Code keeps a small file about every running session in `<config dir>/sessions/` and one about every subagent next to the session's transcript. `agents` reads those files and nothing else. It never writes to them, talks to no session and sends nothing anywhere; `agents update` is the only command that uses the network.

Two things to know:

- **Subagents are an estimate.** Claude Code does not reliably record when a subagent ends, so one counts as running while it wrote to its transcript in the last 5 minutes. A subagent in a long silent step can drop out for a moment, and a finished one can linger for a few minutes.
- **The files are Claude Code's own.** Their format is not documented and may change with a Claude Code update. Written against Claude Code 2.1.

## Uninstall

```sh
rm "$(command -v agents)"
```

or `brew uninstall agents-cli`. The config file, if you made one, is `~/.config/agents/config.json`.

## Develop

```sh
./agents selftest
```

---

<sub>Not affiliated with or endorsed by Anthropic.</sub>
