#!/usr/bin/env bash
# Authenticate the Salesforce CLI from SFDX_AUTH_URL. Idempotent.
set -euo pipefail
: "${SFDX_AUTH_URL:?Set SFDX_AUTH_URL to the sfdxAuthUrl value from 'sf org display --verbose --json'}"
ALIAS="${SF_ALIAS:-devorg}"

if ! command -v sf >/dev/null 2>&1; then
  echo "Salesforce CLI not found. Installing..."
  npm install -g @salesforce/cli >/dev/null 2>&1
fi

echo "$SFDX_AUTH_URL" | sf org login sfdx-url --sfdx-url-stdin --alias "$ALIAS" --set-default >/dev/null
sf org display --target-org "$ALIAS" --json | python3 -c '
import json,sys
r=json.load(sys.stdin)["result"]
print("Logged in")
print("  alias       :", r.get("alias"))
print("  username    :", r.get("username"))
print("  org id      :", r.get("id"))
print("  instance    :", r.get("instanceUrl"))
print("  api version :", r.get("apiVersion"))
'
