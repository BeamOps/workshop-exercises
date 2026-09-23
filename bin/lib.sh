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

# http_ok <url> — succeeds if the URL responds 2xx/3xx (needs curl)
http_ok() { curl -fsS -o /dev/null "$1"; }

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
