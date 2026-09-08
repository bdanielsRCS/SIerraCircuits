# Scripts

Everything here reads credentials from environment variables. Nothing is
pasted into chat or committed. Set these once in the Claude Code environment
settings (Sierra Circuts environment) or export them in your shell.

| Variable | Used by | What it is |
|----------|---------|------------|
| `SFDX_AUTH_URL` | `sf/*` | Output of `sf org display --target-org devorg --verbose --json`, the `sfdxAuthUrl` value starting `force://` |
| `SNOWFLAKE_ACCOUNT` | `snowflake/*` | Account identifier, e.g. `abc12345.us-east-1` or `myorg-myaccount` |
| `SNOWFLAKE_USER` | `snowflake/*` | Your admin user for setup and seed. The service user is created by the setup script. |
| `SNOWFLAKE_PRIVATE_KEY_PATH` | `snowflake/*` | Path to a PKCS8 private key for `SNOWFLAKE_USER`. Preferred. |
| `SNOWFLAKE_PASSWORD` | `snowflake/*` | Fallback if no key. Snowflake may require MFA, in which case use the key. |
| `SNOWFLAKE_ROLE` | `snowflake/*` | Defaults to `ACCOUNTADMIN` |
| `SNOWFLAKE_SVC_PUBLIC_KEY_PATH` | `snowflake/run_sql.py` | Path to `rsa_key.pub` for the DATACLOUD_SVC user. Substituted into `00_setup.sql`. |

## Salesforce

Run in order from the repo root.

```
scripts/sf/01-login.sh             # authenticate CLI from SFDX_AUTH_URL, alias devorg
scripts/sf/02-check-org.sh         # org id, user, Data Cloud provisioned?, Data Cloud permission sets
scripts/sf/03-create-test-user.sh  # create "Bikram Test" user, assign Data Cloud Admin, generate password
scripts/sf/04-fls.sh break         # Scenario A: remove FLS on Contact.Phone and Contact.Title for Standard User
scripts/sf/04-fls.sh restore       # Scenario A: put it back
```

## Snowflake

```
scripts/snowflake/run_sql.py docs/replication/snowflake/00_setup.sql
scripts/snowflake/run_sql.py docs/replication/snowflake/01_seed.sql
scripts/snowflake/run_sql.py docs/replication/snowflake/02_schema_drift.sql   # Scenario E only, after first refresh
```

`run_sql.py` needs the venv at `scripts/snowflake/.venv`. Create it once:

```
python3 -m venv scripts/snowflake/.venv
scripts/snowflake/.venv/bin/pip install snowflake-connector-python
```

## Key pair for the Data Cloud service user

```
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub
```

Keep both files outside the repo or rely on `.gitignore`, which excludes `*.p8`, `*.pub`, and `rsa_key*`.
