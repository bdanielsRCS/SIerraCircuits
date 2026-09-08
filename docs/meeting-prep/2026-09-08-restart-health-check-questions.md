# Sierra Circuits – Restart Health Check: questions for the 2026-09-08 call

Source: "Restart One-Pager: Restart Health Check" (PDF, not yet in this repo).
The questions below are organized by the sections a health-check one-pager
normally carries. Strike anything the document already answers and push on
anything it leaves vague.

## 0. Context from the Gmail thread (Bikram / Lewis)

- Bikram reported a Data Graph access issue blocking Agentforce setup; key CRM
  objects are inaccessible from the graph.
- Lewis asked for user access to diagnose directly. Call set for next Tuesday
  8 AM CST; Lewis may miss it, Bryant attends.
- Data 360 (Data Cloud) status per Bikram: DLO/DMO mapping and unification done,
  Data Graph config fix and validation still pending. He is asking for guidance.

### Lead with these: Data Graph / Agentforce blocker

- Which CRM objects are "inaccessible"? Account, Contact, Case, Opportunity,
  custom objects? Are they inaccessible in the Data Graph builder, in the DMO
  list, or only when the agent tries to retrieve them?
- Which Data Space is the Data Graph in? Do the Agentforce user, the Einstein
  integration user, and Bikram's user all have that Data Space assigned in their
  Data Cloud permission set?
- Were the missing objects ever ingested? Is there a Salesforce CRM connector
  data stream for each one, and does the connector's integration user have read
  access to the object and the fields being mapped?
- Are the objects mapped to DMOs with a primary key and a relationship path back
  to the graph's primary DMO? Data Graph only follows defined DMO relationships.
- Is this a Unified Individual graph or a straight CRM-profile graph? If unified,
  has the identity resolution ruleset run to completion and produced Unified
  Individual and Unified Link records?
- What is the Data Graph status right now: Active, Processing, or Failed? When
  did it last refresh, and what did the error say?
- Are any Data Graph limits in play: number of graphs per org, related-object
  depth, number of fields, or record volume?
- What is Agentforce meant to do with the graph: prompt grounding, an
  Agentforce Data Library, a retriever on a search index, or an Apex/flow action?
  Each needs different permissions and a different graph shape.
- Has Einstein Generative AI and Agentforce been enabled on the org, and is the
  Data Cloud provisioning tied to the same org, not a separate Data Cloud tenant?
- Is the org production or a sandbox? Data Cloud sandboxes have their own
  provisioning and can lag on features.
- What has Bikram already tried, and what does he want from us: a fix, a
  validation of his config, or a design decision?

### Access and logistics

- Confirm Lewis's user-access request is approved and provisioned before the
  Tuesday call. Who is creating the user, and with which permission sets:
  Data Cloud Admin, Data Cloud Data Space, Agentforce/Einstein user?
- Do we get a full-copy sandbox or production? If production, agree on
  change-control rules for anything we touch during diagnosis.
- Get a copy of the current DLO-to-DMO mapping and the identity resolution
  ruleset before Tuesday so the call is spent diagnosing, not discovering.

### Health-check scope implications

- Is the health check scoped to Data 360 and Agentforce only, or the whole CRM
  org? The one-pager should say.
- Is "restart" a restart of the Agentforce build, or of the wider Salesforce
  program? That determines who needs to be interviewed.
- Who owns Data 360 on the client side day to day, and is Bikram that person or
  a partner or Salesforce resource?

## 1. Why now (the "restart")

- What is being restarted? A stalled implementation, a prior partner's work, or a
  system that has drifted since go-live?
- What happened the first time, and what specifically do you want to be different
  this time?
- Who owns the outcome on your side, and who signs off that the health check is done?
- Is there a date driving this (renewal, audit, fiscal year, product launch, ERP
  or MES cutover)?

## 2. Scope boundaries

- Which systems and orgs are in scope? Production only, or sandboxes too?
- Which business functions are in scope: sales and quoting, customer service, order
  management, manufacturing or shop-floor integration, marketing?
- Which integrations are in scope (ERP, quoting engine, web store, e-mail, telephony)?
- What is explicitly out of scope, and what happens if we find a critical issue
  there?
- How many users, profiles, and business units are we assessing?

## 3. Deliverables

- What does the finished health check look like: a scored report, a prioritized
  backlog, a remediation roadmap, an executive readout, or all of these?
- Who is the audience for the readout: executives, IT, end users?
- Do you expect us to fix anything during the health check, or only assess?
- Will you want estimates and pricing for remediation as part of the deliverable?

## 4. Timeline and effort

- What is the expected duration and start date?
- How many hours per week can your team give us for interviews and walkthroughs?
- Are there blackout dates (quarter close, plant shutdowns, trade shows)?

## 5. Access and data

- What access will we get and when: admin login, read-only, metadata export, data
  export?
- Is there a security or vendor-onboarding process we need to clear first, and how
  long does it take?
- Are there compliance constraints on the data we can see (ITAR, export control,
  customer NDAs)? Sierra Circuits builds boards for defense and aerospace
  customers, so this matters.
- Is there existing documentation: architecture diagrams, data dictionary, past
  audit findings, open ticket backlog?

## 6. Known pain points

- What are the top three problems users complain about today?
- Where does the team work around the system in spreadsheets or e-mail?
- Which reports or dashboards does leadership not trust, and why?
- What automations or integrations fail most often?
- Is there technical debt you already know about (unused fields, orphaned
  automations, legacy code, duplicate records)?

## 7. Success criteria

- How will you judge whether the health check was worth it?
- What decision will this report feed: rebuild, remediate, replace, or renew?
- What would make you say "that was a waste of time"?

## 8. People

- Who are the day-to-day contacts for each function in scope?
- Who is the internal admin or developer, and how much of their time is available?
- Are there other partners or vendors involved we need to coordinate with?

## 9. Commercials and assumptions

- Is the health check fixed fee or time and materials? What is the cap?
- What assumptions in the one-pager are load-bearing (user count, number of
  integrations, number of orgs)? What happens if they are wrong?
- Is there a path from the health check into a remediation or managed-services
  engagement, and is that priced separately?
- Who at Sierra Circuits approves the SOW, and what is their procurement lead time?

## 10. Next steps to close the call with

- Agree on a kickoff date and the access-request owner.
- Agree on the list of people to interview and a scheduling contact.
- Agree on where documents will be exchanged.
- Confirm who sends the SOW and by when.

---

## Notes from the call

_(fill in during or after the meeting)_

## Action items

| Owner | Item | Due |
|-------|------|-----|
|       |      |     |
