#!/bin/bash
# AEGIS to GitHub Integration

REPO_DIR="/Volumes/aya_SSD/aya_mission_control/aegis-mission-control"
EXECUTION_LOGS="/Volumes/aya_SSD/aya_mission_control/execution_logs"

# Function to sync latest execution
sync_latest_execution() {
    local latest=$(ls -t "$EXECUTION_LOGS"/*.json 2>/dev/null | head -1)
    if [[ -n "$latest" ]]; then
        "$REPO_DIR/scripts/push_to_github.sh" execution "$latest"
    fi
}

# Function to create and push handover
create_handover() {
    local handover_file="/tmp/aegis_handover_$(date +%Y%m%d_%H%M%S).json"
    
    # Call your existing handover creation script
    python3 "$EXECUTION_LOGS/../aegis_handover_system.py" > "$handover_file"
    
    # Push to GitHub
    "$REPO_DIR/scripts/push_to_github.sh" handover "$handover_file"
}

# Main execution
case "${1:-}" in
    execution) sync_latest_execution ;;
    handover) create_handover ;;
    *) echo "Usage: $0 {execution|handover}" ;;
esac
