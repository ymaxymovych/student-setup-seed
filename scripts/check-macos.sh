#!/usr/bin/env bash
# Read-only status check for student-setup-seed: installs nothing, changes nothing.
# Usage: check-macos.sh [free|premium]
# Exit code: 0 = all OK for the level, 1 = something left to do, 2 = bad argument.

set -u

LEVEL="${1:-free}"
case "$LEVEL" in
  free|premium) ;;
  *) echo "Usage: check-macos.sh [free|premium]"; exit 2 ;;
esac

# Claude's shell may skip ~/.zshrc; node@22 is keg-only, so it goes first.
PATH="/opt/homebrew/opt/node@22/bin:/usr/local/opt/node@22/bin:/opt/homebrew/bin:/usr/local/bin:$PATH:/Applications/Docker.app/Contents/Resources/bin"

PROJECTS="$HOME/Projects"
HELLO_TS="$PROJECTS/hello-ts"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
STATE="$HOME/.claude/student-setup-state.json"
SSH_KEY="$HOME/.ssh/id_ed25519.pub"
TODO=0

row() { # tier item exit_status detail
  local status=OK
  if [ "$3" -ne 0 ]; then
    status=TODO
    if [ "$1" = free ] || [ "$LEVEL" = premium ]; then TODO=$((TODO + 1)); fi
  fi
  printf '%-5s %-8s %-20s %s\n' "$status" "$1" "$2" "$4"
}

has() { command -v "$1" >/dev/null 2>&1; }

# On a clean Mac /usr/bin/git is a stub that pops up an installer dialog.
git_ok() {
  has git && { [ "$(uname)" != Darwin ] || [ "$(command -v git)" != /usr/bin/git ] || xcode-select -p >/dev/null 2>&1; }
}

json_value() { # key -> string value from the state file
  [ -f "$STATE" ] && sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$STATE" | head -n 1
}

printf '%-5s %-8s %-20s %s\n' STATE LEVEL ITEM DETAIL

# Free tier
[ -d "/Applications/Wispr Flow.app" ] || [ -d "$HOME/Applications/Wispr Flow.app" ]
row free "Wispr Flow" $? "/Applications/Wispr Flow.app"
printf '%-5s %-8s %-20s %s\n' INFO free "Chrome extension" "checked by Claude: list tabs with Claude in Chrome"

[ -f "$CLAUDE_MD" ] && grep -Eq 'student-setup-seed:begin v[0-9]+' "$CLAUDE_MD" && grep -q 'student-setup-seed:end' "$CLAUDE_MD"
row free "CLAUDE.md block" $? "$CLAUDE_MD"
[ -d "$PROJECTS" ]
row free "~/Projects" $? "$PROJECTS"

# Premium tier
git_version=""
git_ok && git_version="$(git --version)"
[ -n "$git_version" ]
row premium git $? "$git_version"

git_name=""
git_email=""
if git_ok; then
  git_name="$(git config --global user.name)"
  git_email="$(git config --global user.email)"
fi
[ -n "$git_name" ] && [ -n "$git_email" ]
row premium "git identity" $? "$git_name $git_email"

node_version=""
has node && node_version="$(node -v)"
node_major="${node_version#v}"
node_major="${node_major%%.*}"
[ -n "$node_major" ] && [ "$node_major" -ge 22 ] 2>/dev/null
row premium "node 22+" $? "$node_version"

[ -f "$HELLO_TS/package.json" ] && [ -d "$HELLO_TS/.git" ]
row premium hello-ts $? "$HELLO_TS"

docker_version=""
docker_status=1
if has docker; then
  docker_version="$(docker info --format '{{.ServerVersion}}' 2>/dev/null)"
  docker_status=$?
fi
row premium "docker engine" "$docker_status" "$docker_version"

has gh && gh auth status >/dev/null 2>&1
row premium "gh auth" $? ""

[ -f "$SSH_KEY" ]
row premium "ssh key" $? "$SSH_KEY"

ip="$(json_value server_ip)"
domain="$(json_value domain)"
[ -n "$ip" ]
row premium "server IP (state)" $? "$ip"
[ -n "$domain" ]
row premium "domain (state)" $? "$domain"

dns_status=1
if [ -n "$ip" ] && [ -n "$domain" ] && has nslookup; then
  nslookup "$domain" 2>/dev/null | grep -Fqw "$ip" && dns_status=0
fi
row premium "DNS domain -> IP" "$dns_status" "$domain $ip"

echo "RESULT level=$LEVEL todo=$TODO"
[ "$TODO" -eq 0 ]
