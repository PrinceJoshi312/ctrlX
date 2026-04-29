use serde_json::Value;
use enigo::*;

pub async fn handle(action: String, payload: Value) -> Result<Value, String> {
    let mut enigo = Enigo::new();
    match action.as_str() {
        "mouse_move" => {
            let dx = payload["dx"].as_f64().ok_or("Missing dx")? as i32;
            let dy = payload["dy"].as_f64().ok_or("Missing dy")? as i32;
            enigo.mouse_move_relative(dx, dy);
            Ok(Value::Null)
        }
        "mouse_click" => {
            enigo.mouse_click(MouseButton::Left);
            Ok(Value::Null)
        }
        "hotkey" => {
            let keys = payload["keys"].as_array().ok_or("Missing keys array")?;
            let mut key_enums = Vec::new();
            for k in keys {
                let key_str = k.as_str().ok_or("Invalid key")?.to_lowercase();
                let key_enum = match key_str.as_str() {
                    "ctrl" => Key::Control, "alt" => Key::Alt, "shift" => Key::Shift,
                    "win" => Key::Meta, "enter" => Key::Return,
                    _ if key_str.len() == 1 => Key::Layout(key_str.chars().next().unwrap()),
                    _ => continue,
                };
                key_enums.push(key_enum);
            }
            for &k in &key_enums { enigo.key_down(k); }
            for &k in key_enums.iter().rev() { enigo.key_up(k); }
            Ok(Value::Null)
        }
        _ => Err(format!("Input action '{}' not implemented", action)),
    }
}
