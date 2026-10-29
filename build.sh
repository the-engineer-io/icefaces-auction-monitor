#!/bin/sh
# Builds target/auctionMonitor.war, trying released ICEfaces / ICEpush / Mojarra
# combinations from Maven Central until one resolves and compiles.
set -u
for combo in \
    "3.3.0 3.3.0 2.1.29" \
    "3.3.0 3.3.0 2.1.26" \
    "3.2.0 3.2.0 2.1.29" \
    "3.2.0 3.2.0 2.1.21" \
    "3.1.0 3.1.0 2.1.21"
do
    set -- $combo
    echo "=== Trying ICEfaces $1 / ICEpush $2 / Mojarra $3 ==="
    if mvn -B -q -Dicefaces.version="$1" -Dicepush.version="$2" -Dmojarra.version="$3" clean package; then
        echo "=== Built with ICEfaces $1 / ICEpush $2 / Mojarra $3 ==="
        exit 0
    fi
done
echo "=== No version combination worked ===" >&2
exit 1
