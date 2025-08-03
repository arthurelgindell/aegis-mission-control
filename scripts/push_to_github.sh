#!/bin/bash
# GitHub Push Function - Bulletproof Edition

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TYPE="${1:-}"
FILE="${2:-}"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Validate inputs
if [[ -z "$TYPE" ]] || [[ -z "$FILE" ]]; then
    echo "Usage: $0 {execution|handover} <file>"
    exit 1
fi

if [[ ! -f "$FILE" ]]; then
    echo -e "${RED}File not found: $FILE${NC}"
    exit 1
fi

cd "$REPO_DIR" || exit 1

# Process based on type
case "$TYPE" in
    execution)
        cp "$FILE" "executions/execution_${TIMESTAMP}.json"
        cp "$FILE" "executions/latest.json"
        TARGET="executions/*"
        MSG="Execution update"
        URL="https://github.com/arthurelgindell/aegis-mission-control/blob/main/executions/latest.json"
        ;;
    handover)
        cp "$FILE" "handovers/handover_${TIMESTAMP}.json"
        cp "$FILE" "handovers/LATEST_HANDOVER.json"
        TARGET="handovers/*"
        MSG="Handover update"
        URL="https://github.com/arthurelgindell/aegis-mission-control/blob/main/handovers/LATEST_HANDOVER.json"
        ;;
    *)
        echo -e "${RED}Invalid type: $TYPE${NC}"
        exit 1
        ;;
esac

# Git operations
git add $TARGET
git commit -m "$MSG [$TIMESTAMP]" || { echo "No changes"; exit 0; }
git push origin main || {
    echo -e "${RED}Push failed - pulling and retrying${NC}"
    git pull --rebase origin main
    git push origin main
}

echo -e "${GREEN}✅ Pushed to GitHub successfully${NC}"
echo -e "View at: $URL"
