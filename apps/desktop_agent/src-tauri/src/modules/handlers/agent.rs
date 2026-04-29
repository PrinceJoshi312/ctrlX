use serde_json::Value;
use screenshots::Screen;
use base64::{Engine as _, engine::general_purpose};

pub async fn handle(action: String, _payload: Value) -> Result<Value, String> {
    match action.as_str() {
        "screenshot" => {
            let screens = Screen::all().map_err(|e| e.to_string())?;
            if let Some(screen) = screens.first() {
                let image = screen.capture().map_err(|e| e.to_string())?;
                let buffer = image.to_png().map_err(|e| e.to_string())?;
                let b64 = general_purpose::STANDARD.encode(buffer);
                Ok(serde_json::json!({ "image": b64 }))
            } else {
                Err("No screens found".into())
            }
        }
        _ => Err(format!("Agent action '{}' not implemented", action)),
    }
}
