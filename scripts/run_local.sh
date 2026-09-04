#!/bin/sh
#
# Run WaveX against the Laravel backend on this Mac.
#
#   scripts/run_local.sh                  # use this Mac's LAN IP
#   BASE_URL=http://10.0.2.2:8000/api scripts/run_local.sh -d emulator-5554
#
# Start the backend first:
#   ../backend/scripts/serve_local.sh
#
# A physical phone cannot reach localhost. The default LAN address lets a
# connected phone access the backend; Android emulators may use 10.0.2.2.
# Set FORCE_REGION_SELECTION=true to show the region page even when the app
# already has a valid saved region.

set -eu

PORT="${PORT:-8000}"

if [ -z "${BASE_URL:-}" ]; then
  LAN_IP="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || true)"
  if [ -z "$LAN_IP" ]; then
    echo "Could not detect a LAN IP." >&2
    echo "Set BASE_URL=http://<your-mac-ip>:$PORT/api and try again." >&2
    exit 1
  fi
  BASE_URL="http://$LAN_IP:$PORT/api"
fi

BASE_URL="${BASE_URL%/}"

if ! curl -fsS --max-time 5 "$BASE_URL/countries" >/dev/null; then
  echo "No local WaveX backend is answering at $BASE_URL/countries" >&2
  echo "Start it with: ../backend/scripts/serve_local.sh" >&2
  exit 1
fi

echo "BASE_URL = $BASE_URL"
FORCE_REGION_SELECTION="${FORCE_REGION_SELECTION:-false}"
echo "FORCE_REGION_SELECTION = $FORCE_REGION_SELECTION"
exec flutter run \
  --dart-define=BASE_URL="$BASE_URL/" \
  --dart-define=FORCE_REGION_SELECTION="$FORCE_REGION_SELECTION" \
  "$@"
