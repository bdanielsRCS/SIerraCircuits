#!/usr/bin/env bash
# Scenario A: toggle field-level security on Contact.Phone and Contact.Title for the Standard User profile.
#   04-fls.sh break    -> readable=false (reproduce the Data Graph access error)
#   04-fls.sh restore  -> readable=true, editable=true
set -euo pipefail
ALIAS="${SF_ALIAS:-devorg}"
MODE="${1:-}"
case "$MODE" in
  break)   DIR="$(dirname "$0")/metadata/break-fls" ;;
  restore) DIR="$(dirname "$0")/metadata/restore-fls" ;;
  *) echo "usage: $0 break|restore"; exit 1 ;;
esac
sf project deploy start --target-org "$ALIAS" --metadata-dir "$DIR" --wait 10
echo "Deployed $MODE. Verify by logging in as the test user and opening the Data Graph builder."
