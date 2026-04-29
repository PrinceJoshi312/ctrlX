# Setup & Installation Guide

## 🖥 Desktop Agent Prerequisites
1. **Rust & Cargo**: [Install Rust](https://rustup.rs/)
2. **Tauri Dependencies**: [Tauri Getting Started](https://tauri.app/v1/guides/getting-started/prerequisites)
3. **Playwright Drivers**:
   ```bash
   # In the root or desktop_agent directory
   npx playwright install chromium
   ```

## 📱 Mobile App Prerequisites
1. **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
2. **mDNS/NSD**: Ensure your local network allows UDP traffic for service discovery.

## 🏃 Running the System

### 1. Start the Desktop Agent
```bash
cd apps/desktop_agent
# If using a frontend (Node.js):
npm install
npm run tauri dev
# For a pure Rust agent:
cargo tauri dev
```
Check the terminal for the `--- PAIRING CODE: XXXX ---` log.

### 2. Start the Mobile App
```bash
cd apps/mobile_app
flutter pub get
flutter run
```

### 3. Pairing
1. Tap **Auto-Discover Agent**.
2. Tap **Connect** once your PC is found.
3. Enter the 4-digit PIN from the Desktop Agent terminal.
4. Access the Dashboard!
