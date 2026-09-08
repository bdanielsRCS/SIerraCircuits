#!/usr/bin/env bash
# Launcher for the Data 360 MCP server. Claude Code runs this from .mcp.json.
#
# Credentials, in priority order:
#   1. DATA360_CLIENT_ID + DATA360_CLIENT_SECRET   -> client credentials flow, auto-refreshing (preferred)
#   2. DATA360_ACCESS_TOKEN + DATA360_INSTANCE_URL -> used as-is
#   3. SFDX_AUTH_URL                               -> logs the sf CLI in, then mints an access token from it
#   4. an sf CLI org already authorized as $SF_ALIAS (default: devorg)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
JAR="${D360_JAR:-$ROOT/.tools/d360-mcp-server/target/data360-mcp-server-1.0.0.jar}"
ALIAS="${SF_ALIAS:-devorg}"

log() { echo "[d360.sh] $*" >&2; }

if [ ! -f "$JAR" ]; then
  log "jar not found at $JAR. Run scripts/mcp/build-d360.sh first."
  exit 1
fi

if [ -n "${DATA360_CLIENT_ID:-}" ] && [ -n "${DATA360_CLIENT_SECRET:-}" ]; then
  export DATA360_AUTH_FLOW="client_credentials"
  log "using client credentials flow"
elif [ -n "${DATA360_ACCESS_TOKEN:-}" ] && [ -n "${DATA360_INSTANCE_URL:-}" ]; then
  log "using provided access token"
else
  if ! command -v sf >/dev/null 2>&1; then
    log "sf CLI not found; install with: npm install -g @salesforce/cli"; exit 1
  fi
  if [ -n "${SFDX_AUTH_URL:-}" ]; then
    echo "$SFDX_AUTH_URL" | sf org login sfdx-url --sfdx-url-stdin --alias "$ALIAS" --set-default >/dev/null 2>&1 || true
  fi
  creds=$( (sf org display --target-org "$ALIAS" --json 2>/dev/null || true) | python3 -c '
import json,sys
try:
    r=json.load(sys.stdin)["result"]; print(r["instanceUrl"]+" "+r["accessToken"])
except Exception: pass')
  if [ -z "$creds" ]; then
    log "no sf org '$ALIAS' authorized and no DATA360_* credentials set. Set SFDX_AUTH_URL or run scripts/sf/01-login.sh."; exit 1
  fi
  export DATA360_INSTANCE_URL="${creds%% *}"
  export DATA360_ACCESS_TOKEN="${creds#* }"
  log "minted access token from sf CLI org '$ALIAS' ($DATA360_INSTANCE_URL)"
fi

export DATA360_API_VERSION="${DATA360_API_VERSION:-66.0}"
exec java -jar "$JAR"
