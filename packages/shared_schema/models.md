# Command & Event Architecture

## 1. Request (Command) Structure
Every message sent from Mobile -> Desktop must follow this format:
```json
{
  "id": "uuid-v4",
  "category": "system | input | browser | workflow",
  "action": "string",
  "payload": {},
  "timestamp": "ISO-8601"
}
```

## 2. Response Structure
Every command results in a response from Desktop -> Mobile:
```json
{
  "request_id": "uuid-v4",
  "status": "success | failure | pending",
  "data": {},
  "error": "string | null"
}
```

## 3. Categories
- **System**: `lock`, `volume`, `brightness`, `power`.
- **Input**: `mouse_move`, `mouse_click`, `key_tap`.
- **Browser**: `open_url`, `search`, `tab_close`.
- **Workflow**: `run_macro`, `list_macros`.
