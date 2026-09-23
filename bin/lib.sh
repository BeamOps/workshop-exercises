#!/usr/bin/env bash
# Shared helpers for exercise validators.
#
# Source this from an exercise's ./validate script:
#
#   ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)"
#   source "$ROOT/bin/lib.sh"
#
# Then use require_docker, check / check_msg, the docker helpers, and finish.

set -uo pipefail

# --- output ---------------------------------------------------------------
if [ -t 1 ]; then
  _GREEN=$'\033[32m'; _RED=$'\033[31m'; _YELLOW=$'\033[33m'; _DIM=$'\033[2m'; _RESET=$'\033[0m'
else
  _GREEN=""; _RED=""; _YELLOW=""; _DIM=""; _RESET=""
fi

_PASS=0
_FAIL=0

info() { printf '%s\n' "${_DIM}$*${_RESET}"; }
_ok()  { _PASS=$((_PASS + 1)); printf '  %s✓%s %s\n' "$_GREEN" "$_RESET" "$1"; }
_no()  {
  _FAIL=$((_FAIL + 1))
  printf '  %s✗%s %s\n' "$_RED" "$_RESET" "$1"
  [ -n "${2:-}" ] && printf '      %s%s%s\n' "$_YELLOW" "$2" "$_RESET"
  return 0
}

# check_msg "description" "hint shown on failure" <command...>
# Passes if the command exits 0.
check_msg() {
  local desc="$1" hint="$2"; shift 2
  if "$@" >/dev/null 2>&1; then _ok "$desc"; else _no "$desc" "$hint"; fi
}

# check "description" <command...>  — like check_msg with a generic hint.
check() {
  local desc="$1"; shift
  check_msg "$desc" "failed: $*" "$@"
}

# --- docker helpers -------------------------------------------------------
require_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    _no "docker is installed" "install Docker Desktop: https://www.docker.com/products/docker-desktop"
    finish
  fi
  if ! docker info >/dev/null 2>&1; then
    _no "docker daemon is running" "start Docker Desktop and wait until it is ready"
    finish
  fi
  _ok "docker is installed and the daemon is running"
}

container_exists()  { docker ps -a --format '{{.Names}}' | grep -qx "$1"; }
container_running() { docker ps    --format '{{.Names}}' | grep -qx "$1"; }
image_exists()      { docker image inspect "$1" >/dev/null 2>&1; }

# container_uses_image <name> <image-substring>
container_uses_image() {
  docker inspect --format '{{.Config.Image}}' "$1" 2>/dev/null | grep -q "$2"
}

# container_did <name> <action-substring> [window]
# True if the daemon logged that action for the container recently. Lets us
# verify state-changing steps were actually performed (stop, start, exec),
# not just that the end state happens to be right. Read-only commands like
# `docker ps` / `docker logs` leave no events and can't be checked this way.
#
# Uses Docker's own relative time window (default 1h) rather than the host
# clock, Docker Desktop's daemon runs in a VM whose clock can drift from the
# host, which would make a host-timestamp window miss recent events.
container_did() {
  local name="$1" action="$2" window="${3:-1h}" out
  # Match by name in the raw event stream rather than --filter container=<name>:
  # the name filter needs the container to still exist, but we want this to work
  # after `docker rm` too (exercises that end by removing the container).
  #
  # Capture first, then grep a here-string: piping into `grep -q` makes grep exit
  # on first match, which SIGPIPEs `docker events` and (under `pipefail`) would
  # report the whole pipeline as failed even on a match.
  out="$(docker events --since "$window" --until "0s" --filter "type=container" \
    --format '{{.Actor.Attributes.name}} {{.Action}}' 2>/dev/null)"
  grep -qE "^${name} .*${action}" <<<"$out"
}

# http_ok <url> — succeeds if the URL responds 2xx/3xx (needs curl)
http_ok() { curl -fsS -o /dev/null "$1"; }

# volume_exists <name> — is there a Docker named volume with this name?
volume_exists() { docker volume inspect "$1" >/dev/null 2>&1; }

# network_exists <name> — is there a Docker network with this name?
network_exists() { docker network inspect "$1" >/dev/null 2>&1; }

# network_has_container <network> <container> — is <container> attached to <network>?
network_has_container() {
  local out
  out="$(docker network inspect "$1" --format '{{range .Containers}}{{.Name}} {{end}}' 2>/dev/null)"
  grep -qw "$2" <<<"$out"
}

# can_reach <network> <name> — from a throwaway container on <network>, does
# <name> resolve and respond to ping? (proves name resolution actually works)
can_reach() {
  docker run --rm --network "$1" busybox ping -c1 -W2 "$2" >/dev/null 2>&1
}

# pg_has_db <container> <dbname> — does the Postgres in <container> have <dbname>?
# (capture then grep a here-string, see container_did for why not a pipe to grep -q)
pg_has_db() {
  local out
  out="$(docker exec "$1" psql -U postgres -lqt 2>/dev/null | cut -d'|' -f1)"
  grep -qw "$2" <<<"$out"
}

# pg_has_value <container> <sql> <expected> — run <sql> in the Postgres in
# <container> and check the result contains <expected>. Lets us verify real data
# (e.g. a row) survived, not just that a database exists.
pg_has_value() {
  local out
  out="$(docker exec "$1" psql -U postgres -tAc "$2" 2>/dev/null)"
  grep -q "$3" <<<"$out"
}

# ran_command <extended-regex> — best-effort: did the user run a matching
# command, according to their shell history? Reads the common history files.
# CAVEAT: shells don't always flush history to disk immediately (plain bash
# writes on exit), so this can miss very recent commands. It's the only way to
# observe read-only commands like `docker ps` / `docker logs`, which leave no
# daemon events, but treat a failure as "couldn't confirm", not "definitely
# didn't run it".
ran_command() {
  local pattern="$1" f
  for f in "${HISTFILE:-}" "$HOME/.zsh_history" "$HOME/.bash_history"; do
    [ -n "$f" ] && [ -f "$f" ] || continue
    grep -qE "$pattern" "$f" 2>/dev/null && return 0
  done
  return 1
}

# --- finish ---------------------------------------------------------------
# Print a summary and exit non-zero if any check failed.
finish() {
  printf '\n'
  if [ "$_FAIL" -eq 0 ] && [ "$_PASS" -gt 0 ]; then
    printf '%s✓ all %d checks passed%s\n' "$_GREEN" "$_PASS" "$_RESET"
    exit 0
  fi
  printf '%s%d passed, %d failed%s\n' "$_RED" "$_PASS" "$_FAIL" "$_RESET"
  exit 1
}

# todo <planned checks...> — placeholder for validators not written yet.
todo() {
  printf '%s⚠ this validator is not implemented yet%s\n' "$_YELLOW" "$_RESET"
  info "planned checks: $*"
  exit 2
}
