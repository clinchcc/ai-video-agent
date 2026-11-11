#!/bin/sh
# Check that an API key works: list your drama projects (free, needs the `read` scope).
# Usage: JQSP_API_KEY=... sh examples/check-key.sh        "code": 0 means connected
set -eu
: "${JQSP_API_KEY:?set JQSP_API_KEY (create a key at https://jqsp.com/settings/apikeys)}"
curl -sS "${JQSP_BASE:-https://jqsp.com}/api/v1/drama/projects" \
  -H "Authorization: Bearer $JQSP_API_KEY" | python3 -m json.tool --no-ensure-ascii
