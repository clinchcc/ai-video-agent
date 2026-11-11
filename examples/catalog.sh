#!/bin/sh
# Credit balance, available models and what each action costs (free, any valid key).
# Usage: JQSP_API_KEY=... sh examples/catalog.sh
set -eu
: "${JQSP_API_KEY:?set JQSP_API_KEY (create a key at https://jqsp.com/settings/apikeys)}"
curl -sS "${JQSP_BASE:-https://jqsp.com}/api/v1/catalog" \
  -H "Authorization: Bearer $JQSP_API_KEY" | python3 -m json.tool --no-ensure-ascii
