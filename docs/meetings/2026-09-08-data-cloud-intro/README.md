# 2026-09-08 – Data Cloud intro and Data Graph blocker

Intro call with Sierra Circuits' Salesforce team. Bikramaditya walked through the
Data 360 (Data Cloud) build and showed the two problems blocking them.

- Otter recording and transcript: [otter-transcript.md](otter-transcript.md)
- Granola notes and transcript: [granola-notes.md](granola-notes.md)

## Attendees

| Person | Side | Role on this call |
|--------|------|-------------------|
| Veena | Sierra Circuits | Ran the call, framed the problem |
| Bikramaditya ("Vikram") | Sierra Circuits | Built the Data Cloud config, drove the screen share |
| Vyankatesh ("Venki") | Sierra Circuits | Technical, mostly silent |
| Bryant Daniels | Relkor | Taking over from Lewis, will do the analysis |
| Lewis | Relkor | Did not attend, handed the meeting to Bryant that morning |

## What they have built

- Org is **production**. No sandbox was mentioned.
- Source is **Snowflake via Zero Copy** (data federation). Tables: accounts, contacts,
  leads, engagement activity, outreach and marketing activity.
- Every Snowflake table carries at least one of three keys: Lead ID, Member ID (MID),
  or Email ID. Salesforce record IDs are also stored back in the Snowflake tables.
- DLO to DMO mapping done. Native DMOs where they exist, custom DMOs where they do not.
  Relationships defined between source tables and DMOs.
- Identity resolution ruleset exists, on only a few DMOs, fuzzy match on name,
  email, and phone.
- Two calculated insights for intent score KPIs.
- Unified Individual created; they search Profile Explorer by first name.
- **Data has only been refreshed once**, at initial setup. Bikramaditya has not
  re-run streams since and plans to refresh "once everything is done."

## The two problems

1. **Profile Explorer shows very little.** Unified Individual exists but the
   injected source tables, engagement activity, calculated insights, and even
   native Lead and Contact data do not show on the profile. Salesforce support
   told them "something needs to be created in Data Graph."
2. **Data Graph builder is blocked.** When adding Salesforce objects such as Lead or
   Contact, the builder shows: *"You can't view or create data graph because you
   don't have access to all objects and fields. Contact your Salesforce admin."*
   Lead does not appear in the object list at all.

Also raised: after upstream Snowflake schema changes, some DLO columns show as
"not exist" and will not refresh. Bikramaditya's workaround is to add a duplicate
column under a new name, map that, and leave the dead column unmapped. Bryant said
this is acceptable short term; the cleaner fix is updating API names on the DLO,
which means unmapping first. Recommended opening a Salesforce case.

## What they want

A single profile view: account at the top, with its contacts and leads under it,
and engagement, marketing, and outreach activity attached. Later, Agentforce on
top of that graph.

## Action items

| Owner | Item | Due |
|-------|------|-----|
| Bikramaditya | Email Bryant a temporary production username and password, 2 to 3 days of access | After the call |
| Bryant | Analyze the production Data Cloud config. Report findings before changing anything. | Once access lands |
| Bryant | Open a Salesforce case on zero-copy columns failing to refresh after source schema changes | With access |
| Bryant | Tell the client which best practices are missing | With the analysis |

## Diagnosis plan for when access arrives

Work these in order. Each one can explain both symptoms.

1. **Permissions on the running user.** The Data Graph error is the standard
   message when the user is missing object or field-level access on the CRM
   objects behind the DMOs, or lacks the Data Cloud Admin permission set or the
   Data Space. Check Bikramaditya's profile and permission sets, and the Data
   Space assignment, before touching config.
2. **Are Lead and Contact actually in Data Cloud?** Lead not appearing in the
   graph builder suggests there is no Salesforce CRM connector data stream for
   Lead, so no Lead DMO exists. Check Data Streams for CRM-sourced Account,
   Contact, Lead. Zero Copy from Snowflake does not create them.
3. **Refresh state.** Streams were run once. Identity resolution and calculated
   insights only process what has been ingested and refreshed. Check last-run
   time on every stream, the identity resolution job history, and CI run status.
   A profile can look empty simply because nothing has been processed since the
   rules were written.
4. **Identity resolution coverage.** Rules exist on only a few DMOs. Profile
   Explorer shows Unified Individual plus DMOs linked through Unified Link
   records. Any DMO not in the ruleset, and any DMO without a relationship to
   Individual, will not appear on the profile. Map which DMOs are in the ruleset
   versus which the client expects to see.
5. **Relationship graph to Individual.** For each custom DMO (engagement,
   outreach, marketing activity), confirm a relationship path to Individual or
   Contact Point with correct cardinality. Snowflake keys (Lead ID, MID, Email
   ID) need to land in the fields those relationships join on.
6. **Data Space.** Confirm all DMOs, the ruleset, the CIs, and the user are in the
   same Data Space. Objects in a different Data Space are invisible to the graph.
7. **Zero Copy schema drift.** Capture an example of a "not exist" column with
   its DLO and the Snowflake change that caused it, for the Salesforce case.

Deliverable back to the client: a findings document listing each gap, the fix,
and whether it is config or permissions, before any change is made in production.

## Notes

- Bryant introduced himself on the call as being with Kicksaw. Relkor is the
  consulting partner of record on other engagements; confirm which name the
  client should see on the SOW.
- The client normally grants short-lived access "from our user" for Salesforce
  support. They asked whether Bryant wanted a named user or shared credentials.
  A named user with an audit trail is the better answer for production work.
