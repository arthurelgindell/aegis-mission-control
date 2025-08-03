# CLAUDE CODE OPERATIONAL PROTOCOL
**Version**: 1.0  
**Purpose**: Standardized procedures for AEGIS V3 operations  
**GitHub**: https://github.com/arthurelgindell/aegis-mission-control

## CORE WORKFLOW
```
Claude (Web) → Formulates Prompt → Claude Code Executes → Push to GitHub → Upload to Claude → Analyze → Repeat
```

## EXECUTION PROTOCOL

Every execution MUST:
1. Create execution log with timestamp
2. Capture all output
3. Push to GitHub immediately

Example:
```bash
EXECUTION_ID=$(date +%Y%m%d_%H%M%S)
EXECUTION_LOG="/tmp/execution_${EXECUTION_ID}.json"

# Your task here, capturing output

cd /Volumes/aya_SSD/aya_mission_control/aegis-mission-control
./scripts/push_to_github.sh execution "$EXECUTION_LOG"
```

## HANDOVER PROTOCOL

At 80% thread capacity:
```bash
python3 /Volumes/aya_SSD/aya_mission_control/create_handover.py
```

## QUICK COMMANDS
- Check status: `/Volumes/aya_SSD/aya_mission_control/aegis_status.sh`
- Push execution: `./push_to_github.sh execution <file>`
- Push handover: `./push_to_github.sh handover <file>`
