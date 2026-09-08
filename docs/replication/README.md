# Replicating Sierra Circuits' Data Cloud setup in a developer org

Goal: stage their build in an org we control so the production analysis is
checking hypotheses we have already seen fail and succeed. Five scenarios, each
mapped to a symptom Bikramaditya showed on the 2026-09-08 call.

## What you need

| Item | Notes |
|------|-------|
| Salesforce Developer Edition with Data Cloud | The Data Cloud and Agentforce developer edition, not a plain DE org. Check Setup, search "Data Cloud Setup". If it is not there, sign up for a new one at developer.salesforce.com. |
| Snowflake account | Any edition. Trial is fine. Needs ACCOUNTADMIN once for setup. |
| RSA key pair | Data Cloud's Snowflake connector uses key-pair auth. Commands below. |
| Two Salesforce users | Your admin user, plus a second "Bikram" user to reproduce the permission error. DE orgs allow two full users. |

Generate the key pair on your machine, not in the repo:

```
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub
```

Paste the body of `rsa_key.pub` (strip the BEGIN and END lines, join into one
line) into `00_setup.sql`. Keep `rsa_key.p8` for the connector. Do not commit
either file.

## Part 1: Snowflake

Run in order in a Snowflake worksheet:

1. `snowflake/00_setup.sql`: warehouse, database, schema, read-only role, service user with the public key.
2. `snowflake/01_seed.sql`: six tables shaped like theirs, with their three keys (Lead ID, MID, Email ID) and the Salesforce IDs written back. Includes people who exist as both Lead and Contact with formatting differences so identity resolution has real work.
3. Do **not** run `02_schema_drift.sql` yet. That is Scenario E.

Tables and how they map:

| Snowflake table | Their equivalent | Primary key | Category | Event time |
|-----------------|------------------|-------------|----------|------------|
| ACCOUNTS | company information | ACCOUNT_ID | Profile | none |
| CONTACTS | contact information | MID | Profile | none |
| LEADS | lead information | LEAD_ID | Profile | none |
| ENGAGEMENT_ACTIVITY | engagement | ACTIVITY_ID | Engagement | ACTIVITY_TS |
| OUTREACH_ACTIVITY | outreach activity | OUTREACH_ID | Engagement | SENT_TS |
| MARKETING_ACTIVITY | marketing activity | TOUCH_ID | Engagement | TOUCH_TS |

## Part 2: Data Cloud baseline

Build this once, as your admin user. It mirrors what Bikramaditya described.

Most of these steps can be driven from Claude Code through Salesforce's Data 360
MCP server (see `scripts/README.md`, section "Data 360 MCP server"). It exposes
connections, data streams, DLO/DMO mappings, identity resolution, calculated
insights, data spaces, and query. The click paths below still apply if you
prefer the browser or the API refuses a step.

1. **Connector.** Data Cloud Setup, Connectors, New, Snowflake. Account URL, user `DATACLOUD_SVC`, private key from `rsa_key.p8`, role `DATACLOUD_READER`, warehouse `SIERRA_WH`. Test the connection. If Snowflake is not in the connector list, the DE org does not license it. Fall back to uploading the same tables as CSV; Scenarios A through D still work, only E needs Snowflake.
2. **Data streams.** One per table, database `SIERRA_REPLICA`, schema `CRM`. Set category and primary key from the table above. For Engagement streams, set the event time field. Leave refresh on the default schedule. Run each stream once.
3. **DLO to DMO mapping.**
   - ACCOUNTS to Account (native). Map ACCOUNT_ID to Id, COMPANY_NAME to Name.
   - CONTACTS to Individual and Contact Point Email and Contact Point Phone. MID to Individual Id. EMAIL_ID to Contact Point Email. PHONE to Contact Point Phone. ACCOUNT_ID to the Account relationship.
   - LEADS to Individual, Contact Point Email, Contact Point Phone. LEAD_ID to Individual Id.
   - ENGAGEMENT_ACTIVITY, OUTREACH_ACTIVITY, MARKETING_ACTIVITY: create custom DMOs. Map LEAD_ID, MID, and EMAIL_ID as fields, then define a relationship from each custom DMO to Individual on whichever key is populated. This is the part most likely to be wrong in their org: Profile Explorer only shows DMOs with a defined relationship to Individual.
4. **Identity resolution.** One ruleset on Individual. Match rules: exact normalized email, then fuzzy first name plus last name plus normalized phone. Reconciliation: last updated. Do **not** run it yet; Scenario C depends on that.
5. **Calculated insight.** One "Intent Score" summing MARKETING_ACTIVITY.INTENT_POINTS per Unified Individual. Do not run.
6. **Second user.** Create a user "Bikram Test" on a cloned Standard User profile. Assign the Data Cloud Admin permission set. Do not assign the Data Space yet.

Record the state after step 6. This is your "as found" baseline.

## Part 3: Scenarios

Each scenario states what to change, what you expect to see, and what it
proves about their org. Reset between scenarios where noted.

### Scenario A: Data Graph permission error

**Their symptom:** "You can't view or create data graph because you don't have access to all objects and fields. Contact your Salesforce admin."

1. Log in as Bikram Test. Open Data Cloud, Data Graphs, New. Try to add Contact.
2. Expect the error. Cause: no Data Space on the user.
3. Assign the default Data Space permission set to Bikram Test. Retry. Expect the builder to open.
4. Now remove field-level security on two Contact fields (say, Phone and Title) from the cloned profile. Retry. Expect the error again.
5. Restore FLS. Retry. Expect it to work.

**Proves:** the error has two independent causes, Data Space and FLS. In prod, check both before touching config.

### Scenario B: Lead missing from the graph builder

**Their symptom:** Lead does not appear in the object list when building a Data Graph.

1. As admin, confirm there is no Salesforce CRM connector stream for Lead. There should not be; Part 2 only ingested Snowflake.
2. Open the graph builder. Search Lead. Expect it absent. The LEADS Snowflake stream maps to Individual, not to a Lead DMO.
3. Add a Salesforce CRM connector stream for Lead. Wait for it to run. Search again. Expect Lead present.

**Proves:** Zero Copy from Snowflake does not create CRM object DMOs. If their graph builder has no Lead, look at Data Streams first.

### Scenario C: empty Profile Explorer

**Their symptom:** Unified Individual exists but shows almost nothing. No activity, no calculated insights, native Lead and Contact fields missing.

1. Open Profile Explorer. Search "Mei". Expect a Unified Individual with only name and email, no related activity. This is their current state: streams ran once, ruleset never ran, CI never ran.
2. Run the identity resolution ruleset. Wait for it to finish. Check the job history for the count of unified individuals and unified links. Expect Mei Tanaka (contact M-5003 and lead L-9001) to resolve to one profile, and Hannah Brooks (L-9003 and L-9006) to resolve to one.
3. Search "Mei" again. Expect Contact Point Email and Phone, plus ENGAGEMENT_ACTIVITY and OUTREACH_ACTIVITY related lists, if the relationships from step 3 of Part 2 are defined.
4. Run the calculated insight. Search again. Expect Intent Score on the profile.
5. Now break it: remove the relationship from MARKETING_ACTIVITY to Individual. Search again. Expect marketing touches gone from the profile even though the data is ingested.

**Proves:** three separate things each empty the profile: ruleset not run, CI not run, and a DMO with no relationship path to Individual. Their org has probably all three.

### Scenario D: the target model

**Their goal:** account at the top, contacts and leads under it, activity attached.

1. With Scenario C fixed, open Profile Explorer on Halcyon Avionics via Account.
2. Confirm Priya Raman, Daniel Okafor, and Tomás Silva appear under the account with their engagement and outreach.
3. Build a Data Graph with Account as primary, related Individual, related Contact Point Email, related ENGAGEMENT_ACTIVITY. Activate it. This is the shape Agentforce will ground on.

**Proves:** the model they want works on the native DMOs plus three custom activity DMOs. Nothing exotic needed.

### Scenario E: Zero Copy schema drift

**Their symptom:** after a Snowflake change, columns show "not exist" in the DLO and will not refresh. Workaround was duplicating the column under a new name.

1. Confirm the ACCOUNTS stream has run and ORDER_EXISTS and QUOTE_COUNT are mapped.
2. Run `snowflake/02_schema_drift.sql`.
3. Refresh the ACCOUNTS stream. Expect the refresh to fail or the two drifted columns to show as unavailable. ANNUAL_REVENUE_USD should be addable as a new field, which matches what he saw.
4. Try the clean fix: unmap ORDER_EXISTS, edit the DLO field to point at FAMES_ORDER_EXIST, remap. Note how many steps it takes. That is the cost he avoided with the duplicate-column workaround.
5. Screenshot the error text. That goes in the Salesforce case.

**Proves:** whether the drift is expected connector behavior or something specific to their tenant. If it reproduces cleanly here, the case is about process, not a bug.

## Recording results

Add a row per scenario to `results.md` in this folder as you go: date, what you
did, what you saw, screenshot filename. Those rows become the "expected
behavior" column in the findings document for the client.
