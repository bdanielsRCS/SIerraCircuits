#!/usr/bin/env bash
# Verify the org and whether Data Cloud is provisioned.
set -euo pipefail
ALIAS="${SF_ALIAS:-devorg}"
API="${SF_API_VERSION:-64.0}"

echo "== Org =="
sf data query --target-org "$ALIAS" --json \
  -q "SELECT Id, Name, OrganizationType, IsSandbox, InstanceName FROM Organization" \
  | python3 -c 'import json,sys; r=json.load(sys.stdin)["result"]["records"][0]; [print(f"  {k:<16}: {v}") for k,v in r.items() if k!="attributes"]'

echo "== Running user =="
sf data query --target-org "$ALIAS" --json \
  -q "SELECT Id, Username, Profile.Name FROM User WHERE Id = '$(sf org display --target-org "$ALIAS" --json | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"].get("userId") or "")')'" \
  2>/dev/null | python3 -c 'import json,sys
try:
  r=json.load(sys.stdin)["result"]["records"][0]; print("  ", r["Username"], "/", r["Profile"]["Name"])
except Exception: print("   (could not resolve user id, skipping)")'

echo "== Data Cloud permission sets =="
sf data query --target-org "$ALIAS" --json \
  -q "SELECT Name, Label FROM PermissionSet WHERE (Label LIKE '%Data Cloud%' OR Label LIKE '%Data 360%' OR Name LIKE 'CDP%' OR Name LIKE 'DataCloud%') AND IsOwnedByProfile = false ORDER BY Label" \
  | python3 -c 'import json,sys
recs=json.load(sys.stdin)["result"]["records"]
if not recs: print("   none found. Data Cloud is probably not provisioned.")
for r in recs: print(f"   {r[\"Label\"]:<45} {r[\"Name\"]}")'

echo "== Data Cloud metadata API =="
if out=$(sf api request rest "/services/data/v${API}/ssot/metadata" --target-org "$ALIAS" 2>&1); then
  echo "$out" | python3 -c 'import json,sys
try:
  d=json.load(sys.stdin); m=d.get("metadata",d)
  n=len(m) if isinstance(m,list) else "?"
  print(f"   reachable. {n} data model objects returned.")
except Exception as e: print("   reachable, non-JSON response:", str(e)[:80])'
else
  echo "   NOT reachable. Data Cloud is not provisioned on this org, or the user lacks Data Cloud access."
  echo "   $(echo "$out" | head -3)"
fi

echo "== Connected users (for the two-user limit) =="
sf data query --target-org "$ALIAS" --json \
  -q "SELECT Username, Profile.Name, IsActive FROM User WHERE UserType='Standard' ORDER BY CreatedDate" \
  | python3 -c 'import json,sys
for r in json.load(sys.stdin)["result"]["records"]: print(f"   {r[\"Username\"]:<50} {r[\"Profile\"][\"Name\"]:<25} active={r[\"IsActive\"]}")'
