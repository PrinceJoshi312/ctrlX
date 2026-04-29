# CtrlX - Lightweight Desktop Control System

CtrlX is a high-performance, command-based mobile-to-PC control system. Unlike traditional screen-streaming apps, CtrlX focuses on **atomic commands** and **automation**, resulting in near-zero latency and minimal bandwidth usage.

## 🚀 Key Features
- **Native OS Control**: Lock workstation, Volume/Media management.
- **Process Control**: Open and close applications by name.
- **Remote Input**: Real-time Trackpad (mouse move/click) and Keyboard text injection.
- **Browser Automation**: Automated Google, YouTube, and GitHub searches via Playwright.
- **Macros & Workflows**: Sequential execution of multiple commands with local persistence.
- **Privacy First**: Secure 4-digit PIN pairing and LAN-only communication.

## 🛠 Tech Stack
- **Mobile**: Flutter + Riverpod (State Management).
- **Desktop Agent**: Tauri + Rust (Tokio for Async, Socketioxide for Transport).
- **Automation**: Playwright (Browser), Enigo (Input), Sysinfo (Process Mgmt).
- **Communication**: Socket.IO over LAN with mDNS Discovery.

## 📁 Project Structure
- `apps/mobile_app`: The Flutter client application.
- `apps/desktop_agent`: The Rust-based system agent.
- `packages/shared_schema`: Documentation for the communication protocol.
- `docs/`: In-depth setup and development guides.

## 🏁 Quick Start
1. **Desktop**: `cd apps/desktop_agent/src-tauri && cargo tauri dev`
2. **Mobile**: `cd apps/mobile_app && flutter run`
3. **Connect**: Use the "Auto-Discover" button on the mobile app and enter the PIN displayed in the desktop terminal.

---
*Refer to the `docs/` folder for detailed setup and development instructions.*
