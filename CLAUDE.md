# Sierra Circuits engagement

Relkor Cloud Solutions engagement with Sierra Circuits (PCB manufacturer,
Sunnyvale CA). Bryant Daniels is the Salesforce architect. The work is a
"Restart Health Check" on a stalled Salesforce Data 360 (Data Cloud) and
Agentforce build.

## Where things are

| Path | What |
|------|------|
| `docs/meetings/2026-09-08-data-cloud-intro/` | Notes and transcripts from the intro call. Read `README.md` there first. |
| `docs/meeting-prep/` | Question lists prepared before calls |
| `docs/replication/README.md` | Runbook: replicate the client's Data Cloud setup in our dev org, five scenarios |
| `docs/replication/snowflake/*.sql` | Snowflake DDL, seed data, and a schema-drift script that mirror the client's tables |
| `scripts/README.md` | Every runnable script and the env vars they need |
| `scripts/sf/` | Salesforce CLI scripts: login, org check, test user, FLS toggle |
| `scripts/snowflake/run_sql.py` | Runs the SQL files against Snowflake |
| `scripts/mcp/` | Build and launch Salesforce's Data 360 MCP server |
| `.mcp.json` | Registers the Data 360 MCP server with Claude Code |

## Client context in one paragraph

Client org is production. They ingest Snowflake tables (accounts, contacts,
leads, engagement, outreach, marketing activity) into Data Cloud via Zero Copy.
Keys per table: Lead ID, MID, or Email ID. DLO to DMO mapping is done,
identity resolution rules exist on a few DMOs, two calculated insights exist.
Streams have only been refreshed once. Two symptoms: Profile Explorer is
nearly empty, and the Data Graph builder shows "you don't have access to all
objects and fields" and does not list Lead. Bikramaditya (client) is sending
Bryant temporary prod credentials for 2 to 3 days. Bryant committed to an
analysis with no changes before review, and to opening a Salesforce case on
Zero Copy columns that fail to refresh after source schema changes.

## Dev org

- Domain: `orgfarm-7d4f0c62ef-dev-ed.develop.my.salesforce.com`
- sf CLI alias expected: `devorg`. Override with `SF_ALIAS` if yours differs.
- Not yet confirmed: whether Data Cloud is provisioned, whether an External
  Client App exists. `scripts/sf/02-check-org.sh` answers the first.

## Working locally

1. `scripts/mcp/build-d360.sh` once per machine. Needs Java 17+ and Maven.
2. Claude Code loads `.mcp.json` from the repo root and launches the server
   through `scripts/mcp/d360.sh`, which mints a token from the `devorg` CLI
   login. No env vars needed if the CLI is already authorized.
3. Run `scripts/sf/02-check-org.sh` before anything else.

## Conventions

- Never commit keys, tokens, or auth URLs. `.gitignore` covers `*.p8`,
  `*.pub`, `rsa_key*`, `.env`, `.tools/`.
- Meeting notes go in `docs/meetings/<date>-<slug>/` with a `README.md`.
- Work happens on branch `claude/sierra-circuits-meeting-rqtehx` until a
  default branch exists. The GitHub repo has no `main` yet.

## Next steps as of 2026-09-08

1. Confirm Data Cloud is provisioned in the dev org.
2. Run replication Scenarios A through C from `docs/replication/README.md`.
3. When client prod credentials arrive, work the diagnosis plan in
   `docs/meetings/2026-09-08-data-cloud-intro/README.md`.
4. Open the Salesforce case on Zero Copy schema drift.
