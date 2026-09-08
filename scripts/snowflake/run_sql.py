#!/usr/bin/env python3
"""Run one or more SQL files against Snowflake using env-var credentials.

Usage: run_sql.py FILE [FILE ...]

Env:
  SNOWFLAKE_ACCOUNT, SNOWFLAKE_USER            required
  SNOWFLAKE_PRIVATE_KEY_PATH  or SNOWFLAKE_PASSWORD
  SNOWFLAKE_ROLE                               default ACCOUNTADMIN
  SNOWFLAKE_WAREHOUSE                          optional
  SNOWFLAKE_SVC_PUBLIC_KEY_PATH                if set, replaces <PUBLIC_KEY_BODY> in the SQL
"""
import os, re, sys, pathlib

try:
    import snowflake.connector
except ImportError:
    here = pathlib.Path(__file__).resolve().parent
    sys.exit(f"snowflake-connector-python not installed. Run:\n  {here}/.venv/bin/pip install snowflake-connector-python\nthen invoke with {here}/.venv/bin/python")


def connect():
    kw = dict(
        account=os.environ["SNOWFLAKE_ACCOUNT"],
        user=os.environ["SNOWFLAKE_USER"],
        role=os.environ.get("SNOWFLAKE_ROLE", "ACCOUNTADMIN"),
    )
    if os.environ.get("SNOWFLAKE_WAREHOUSE"):
        kw["warehouse"] = os.environ["SNOWFLAKE_WAREHOUSE"]
    key_path = os.environ.get("SNOWFLAKE_PRIVATE_KEY_PATH")
    if key_path:
        from cryptography.hazmat.primitives import serialization
        with open(key_path, "rb") as f:
            pk = serialization.load_pem_private_key(f.read(), password=None)
        kw["private_key"] = pk.private_bytes(
            serialization.Encoding.DER,
            serialization.PrivateFormat.PKCS8,
            serialization.NoEncryption(),
        )
    elif os.environ.get("SNOWFLAKE_PASSWORD"):
        kw["password"] = os.environ["SNOWFLAKE_PASSWORD"]
    else:
        sys.exit("Set SNOWFLAKE_PRIVATE_KEY_PATH or SNOWFLAKE_PASSWORD")
    return snowflake.connector.connect(**kw)


def public_key_body():
    p = os.environ.get("SNOWFLAKE_SVC_PUBLIC_KEY_PATH")
    if not p:
        return None
    lines = [l.strip() for l in open(p) if "BEGIN" not in l and "END" not in l]
    return "".join(lines)


def split_statements(sql):
    # Strip line comments, then split on semicolons. Good enough for these files.
    sql = re.sub(r"--[^\n]*", "", sql)
    return [s.strip() for s in sql.split(";") if s.strip()]


def main(files):
    conn = connect()
    cur = conn.cursor()
    pub = public_key_body()
    try:
        for path in files:
            print(f"== {path}")
            sql = open(path).read()
            if "<PUBLIC_KEY_BODY>" in sql:
                if not pub:
                    sys.exit("This file needs SNOWFLAKE_SVC_PUBLIC_KEY_PATH to fill <PUBLIC_KEY_BODY>")
                sql = sql.replace("<PUBLIC_KEY_BODY>", pub)
            for stmt in split_statements(sql):
                first = " ".join(stmt.split())[:90]
                try:
                    cur.execute(stmt)
                    rows = cur.fetchall() if cur.description else []
                    tag = f"{len(rows)} row(s)" if cur.description else "ok"
                    print(f"  ok   {first}  -> {tag}")
                    if cur.description and len(rows) <= 40 and rows:
                        cols = [d[0] for d in cur.description]
                        print("       " + " | ".join(cols))
                        for r in rows:
                            print("       " + " | ".join(str(v) for v in r))
                except Exception as e:
                    print(f"  FAIL {first}\n       {e}")
                    sys.exit(1)
    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    main(sys.argv[1:])
