#!/bin/sh
# Latest availability check of every model: available / degraded / unavailable / unknown
# (free, any valid key).
# Usage: JQSP_API_KEY=... sh examples/model-status.sh
set -eu
: "${JQSP_API_KEY:?set JQSP_API_KEY (create a key at https://jqsp.com/settings/apikeys)}"
curl -sS "${JQSP_BASE:-https://jqsp.com}/api/v1/model-status" \
  -H "Authorization: Bearer $JQSP_API_KEY" | python3 -m json.tool --no-ensure-ascii
