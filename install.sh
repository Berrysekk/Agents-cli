#!/bin/sh
# Installs the `agents` command for the logged-in user.
#   curl -fsSL https://raw.githubusercontent.com/Berrysekk/Agents-cli/main/install.sh | sh
# Uninstall: rm "$(command -v agents)"
set -eu

repo=Berrysekk/Agents-cli
again="curl -fsSL https://raw.githubusercontent.com/$repo/main/install.sh | sh"

# What went wrong, and the command that fixes it.
red="" bold="" plain=""
[ -t 2 ] && red=$(printf '\033[31m') bold=$(printf '\033[1m') plain=$(printf '\033[0m')
fail() {
  printf '\n%s✗%s %s\n' "$red" "$plain" "$1" >&2
  [ -z "${2:-}" ] || printf '  Fix: %s%s%s\n' "$bold" "$2" "$plain" >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 && python3 -c 'import sys; sys.exit(sys.version_info < (3, 9))' 2>/dev/null \
  || fail "agents needs Python 3.9 or later as python3." "xcode-select --install   (macOS; on Linux, python3 from your package manager)"

# A folder of its own, and Python's isolated mode: nothing next to the download can be imported by it.
dir=$(mktemp -d)
tmp="$dir/agents"
trap 'rm -rf "$dir"' EXIT
# A local copy (AGENTS_FILE=./agents) instead of the latest one.
if [ -n "${AGENTS_FILE:-}" ]; then
  cp "$AGENTS_FILE" "$tmp" || fail "There is no file at $AGENTS_FILE."
else
  curl -fsSL --retry 2 -o "$tmp" "https://raw.githubusercontent.com/$repo/main/agents" \
    || fail "Downloading agents failed. Check the internet connection." "$again"
fi
version=$(python3 -I "$tmp" version 2>/dev/null) || fail "The download is not agents (cut short?)." "$again"

# The command goes into a directory that is already on the PATH, so it works in this terminal straight away.
on_path() { case ":$PATH:" in *":$1:"*) return 0 ;; esac; return 1; }
put() { cp "$tmp" "$1/agents" 2>/dev/null && chmod 755 "$1/agents"; }
bin=""
for candidate in "$HOME/.local/bin" "$HOME/bin" /opt/homebrew/bin /usr/local/bin; do
  on_path "$candidate" || continue
  [ -d "$candidate" ] || mkdir -p "$candidate" 2>/dev/null || continue
  if [ -w "$candidate" ] && put "$candidate"; then bin=$candidate; break; fi
done
if [ -z "$bin" ]; then
  bin="$HOME/.local/bin"
  mkdir -p "$bin" && put "$bin" || fail "The agents command could not be put in $bin." "$again"
  echo "Installed $version in $bin, which is not on your PATH yet. Add it, then run agents:"
  echo '  export PATH="$HOME/.local/bin:$PATH"'
  exit 0
fi
echo "Installed $version in $bin. Run: agents"
