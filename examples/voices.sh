#!/bin/sh
# List the voices you can use for voice-over and characters (free, needs the `read` scope).
# Usage: JQSP_API_KEY=... sh examples/voices.sh
set -eu
: "${JQSP_API_KEY:?set JQSP_API_KEY (create a key at https://jqsp.com/settings/apikeys)}"
curl -sS "${JQSP_BASE:-https://jqsp.com}/api/v1/voices" \
  -H "Authorization: Bearer $JQSP_API_KEY" | python3 -m json.tool --no-ensure-ascii
