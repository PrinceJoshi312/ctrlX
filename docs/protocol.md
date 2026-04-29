# Communication Protocol (v1.0)

CtrlX uses a strict Request-Response pattern over Socket.IO.

## 📡 Transport Layer
- **Port**: 3000 (Default)
- **Discovery**: mDNS Service `_ctrlx._tcp.local`
- **Handshake**: 4-Digit PIN via `pair` event.

## 📥 Commands (Mobile -> Agent)
**Event Name**: `command`
```json
{
  "id": "uuid-v4",
  "category": "system | input | agent | browser | workflow",
  "action": "string",
  "payload": { ... },
  "timestamp": "ISO-8601"
}
```

### Common Actions
| Category | Action | Payload Example |
| :--- | :--- | :--- |
| `system` | `lock` | `{}` |
| `system` | `open_app` | `{"name": "notepad"}` |
| `input` | `mouse_move` | `{"dx": 10, "dy": -5}` |
| `browser` | `google_search` | `{"query": "Rust tutorials"}` |
| `workflow` | `run` | `{"name": "daily_start"}` |

## 📤 Responses (Agent -> Mobile)
**Event Name**: `command_response`
```json
{
  "request_id": "uuid-v4",
  "status": "success | failure",
  "data": { ... },
  "error": "string | null"
}
```

## 📸 Specialized Data
- **Screenshots**: Sent as a Base64 PNG string in the `data.image` field of a response.
