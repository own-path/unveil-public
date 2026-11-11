# Sourced by release steps. This repository is public, so its Actions logs are
# readable by anyone, while the source being built is private. `quiet` sends a
# command's output to a private log file and prints only whether it passed.
# seal-logs encrypts those files at the end of each job; only the holder of the
# private key (~/.unveil-release/logs-key.pem on the release Mac) can read them.
#
#   quiet "<step name>" <command> [args...]
RELEASE_LOGS="${RUNNER_TEMP//\\//}/release-logs"
mkdir -p "$RELEASE_LOGS"

quiet() {
  local name=$1
  shift
  local log
  log="$RELEASE_LOGS/$(printf '%s' "$name" | tr -c 'A-Za-z0-9._-' '_').log"
  local started=$SECONDS
  if "$@" >"$log" 2>&1; then
    echo "ok: $name ($((SECONDS - started))s)"
  else
    local status=$?
    echo "::error::$name failed (exit $status). Its full log is in this job's encrypted logs artifact."
    return "$status"
  fi
}
