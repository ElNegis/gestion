#!/usr/bin/env bash
set -euo pipefail

URL="http://localhost:3000/api/query?q=ci-test"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "✅ /api/query OK (200)"
  exit 0
else
  echo "❌ /api/query falló con HTTP $HTTP_CODE"
  exit 1
fi