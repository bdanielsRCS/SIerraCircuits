#!/usr/bin/env bash
# Create the "Bikram Test" user for Scenario A and assign Data Cloud Admin.
# Does NOT assign the Data Space permission set; that is Scenario A step 3.
set -euo pipefail
ALIAS="${SF_ALIAS:-devorg}"
ORG_DOMAIN=$(sf org display --target-org "$ALIAS" --json | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["instanceUrl"].replace("https://",""))')
USERNAME="${TEST_USERNAME:-bikram.test@${ORG_DOMAIN}}"
EMAIL="${TEST_USER_EMAIL:-bryant.daniels@relkorcs.com}"

existing=$(sf data query --target-org "$ALIAS" --json -q "SELECT Id FROM User WHERE Username='${USERNAME}'" \
  | python3 -c 'import json,sys; r=json.load(sys.stdin)["result"]["records"]; print(r[0]["Id"] if r else "")')

if [ -n "$existing" ]; then
  echo "User already exists: $USERNAME ($existing)"
  USER_ID="$existing"
else
  PROFILE_ID=$(sf data query --target-org "$ALIAS" --json -q "SELECT Id FROM Profile WHERE Name='Standard User'" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["records"][0]["Id"])')
  USER_ID=$(sf data create record --target-org "$ALIAS" --sobject User --json --values \
    "Username='${USERNAME}' LastName='Test' FirstName='Bikram' Alias='bikram' Email='${EMAIL}' ProfileId='${PROFILE_ID}' EmailEncodingKey='UTF-8' LanguageLocaleKey='en_US' LocaleSidKey='en_US' TimeZoneSidKey='America/Chicago'" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["id"])')
  echo "Created user: $USERNAME ($USER_ID)"
fi

echo "== Assigning Data Cloud Admin =="
PS=$(sf data query --target-org "$ALIAS" --json \
  -q "SELECT Id, Name, Label FROM PermissionSet WHERE (Label = 'Data Cloud Admin' OR Name = 'CDPAdmin' OR Name = 'DataCloudAdmin') AND IsOwnedByProfile = false LIMIT 1" \
  | python3 -c 'import json,sys; r=json.load(sys.stdin)["result"]["records"]; print(r[0]["Id"]+"|"+r[0]["Label"] if r else "")')
if [ -z "$PS" ]; then
  echo "   Data Cloud Admin permission set not found. Data Cloud is not provisioned. Stop here."
  exit 1
fi
PS_ID="${PS%%|*}"; PS_LABEL="${PS#*|}"
already=$(sf data query --target-org "$ALIAS" --json -q "SELECT Id FROM PermissionSetAssignment WHERE AssigneeId='${USER_ID}' AND PermissionSetId='${PS_ID}'" \
  | python3 -c 'import json,sys; print(len(json.load(sys.stdin)["result"]["records"]))')
if [ "$already" = "0" ]; then
  sf data create record --target-org "$ALIAS" --sobject PermissionSetAssignment --values "AssigneeId='${USER_ID}' PermissionSetId='${PS_ID}'" >/dev/null
  echo "   assigned: $PS_LABEL"
else
  echo "   already assigned: $PS_LABEL"
fi

echo "== Password =="
sf org generate password --target-org "$ALIAS" --on-behalf-of "$USERNAME" --json \
  | python3 -c 'import json,sys; r=json.load(sys.stdin)["result"]; r=r[0] if isinstance(r,list) else r; print("   username:", r.get("username")); print("   password:", r.get("password"))' \
  || echo "   could not generate password via CLI. Reset it from Setup > Users instead."

echo
echo "Next for Scenario A: log in as $USERNAME and open Data Cloud > Data Graphs > New. Expect the access error."
