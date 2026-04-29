# Developer Guide: Extending CtrlX

The project is built with strict domain separation to ensure ease of extension.

## 🛠 Adding a New Command Category
1. **Desktop**: Create a new file in `apps/desktop_agent/src-tauri/src/modules/handlers/`.
2. **Desktop**: Implement the `pub async fn handle(action: String, payload: Value) -> Result<Value, String>` function.
3. **Desktop**: Register the module in `handlers/mod.rs` inside the `dispatch` match statement.
4. **Mobile**: Add a new panel in `lib/ui/panels/` or update an existing one.

## 🏗 Modular Architecture
### Desktop (Rust)
- `transport`: Socket.IO server and mDNS advertiser.
- `handlers/`: Domain-specific logic (System, Input, etc.).
- `automation`: Async Playwright engine.
- `workflows`: Macro persistence and execution engine.

### Mobile (Flutter)
- `modules/`: Headless services (Socket, Discovery, History).
- `ui/panels/`: Major navigation screens.
- `ui/widgets/`: Reusable components (Control buttons, indicators).

## 🧪 Testing
- **Rust**: Use `cargo test` for logic in `handlers`.
- **Flutter**: Use `flutter test` for Riverpod state logic.
