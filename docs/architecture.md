# System Architecture - CtrlX

## Overview
CtrlX uses a command-based architecture rather than video streaming to minimize latency and bandwidth.

## Communication Flow
1. **Mobile App** discovers **Desktop Agent** via LAN (mDNS).
2. **Mobile App** sends a JSON command (e.g., `{"type": "system.lock"}`).
3. **Desktop Agent** validates the command and executes the native handler.
4. **Desktop Agent** returns a status or screenshot if requested.

## Module Map
- `transport`: Handles Socket.IO connection and pairing.
- `handlers`: Maps JSON commands to Rust/OS actions.
- `automation`: Orchestrates Playwright for browser tasks.
- `workflows`: Manages saved macros and sequences.
