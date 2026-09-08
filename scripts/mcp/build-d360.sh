#!/usr/bin/env bash
# Clone and build Salesforce's Data 360 MCP server into .tools/ (gitignored).
# Needs Java 17+ and Maven 3.9+. First build downloads Spring dependencies; allow 3 to 5 minutes.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DIR="$ROOT/.tools/d360-mcp-server"
JAR="$DIR/target/data360-mcp-server-1.0.0.jar"

if [ -f "$JAR" ] && [ "${1:-}" != "--force" ]; then
  echo "Already built: $JAR"; exit 0
fi
mkdir -p "$ROOT/.tools"
if [ ! -d "$DIR/.git" ]; then
  git clone --depth 1 https://github.com/forcedotcom/d360-mcp-server.git "$DIR"
else
  git -C "$DIR" pull --ff-only
fi
cd "$DIR"
mvn -q -B package -DskipTests
ls -la "$JAR"
echo "Built. Claude Code will launch it through scripts/mcp/d360.sh (see .mcp.json)."
