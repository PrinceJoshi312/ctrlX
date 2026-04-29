use serde_json::Value;
use enigo::*;
use std::process::Command;
use sysinfo::{ProcessExt, System, SystemExt};

pub async fn handle(action: String, payload: Value) -> Result<Value, String> {
    match action.as_str() {
        "lock" => {
            #[cfg(target_os = "windows")]
            Command::new("rundll32.exe").args(&["user32.dll,LockWorkStation"]).spawn().map_err(|e| e.to_string())?;
            Ok(Value::Null)
        }
        "volume" => {
            let mut enigo = Enigo::new();
            match payload["action"].as_str().unwrap_or("") {
                "up" => enigo.key_click(Key::VolumeUp),
                "down" => enigo.key_click(Key::VolumeDown),
                "mute" => enigo.key_click(Key::VolumeMute),
                _ => return Err("Invalid volume action".into()),
            }
            Ok(Value::Null)
        }
        "open_app" => {
            let name = payload["name"].as_str().ok_or("Missing app name")?;
            Command::new("cmd").args(&["/C", "start", "", name]).spawn().map_err(|e| e.to_string())?;
            Ok(Value::Null)
        }
        "close_app" => {
            let name = payload["name"].as_str().ok_or("Missing app name")?;
            let mut s = System::new_all();
            s.refresh_processes();
            for process in s.processes_by_exact_name(name) {
                process.kill();
            }
            Ok(Value::Null)
        }
        "text" => {
            let mut enigo = Enigo::new();
            let text = payload["text"].as_str().ok_or("Missing text")?;
            enigo.key_sequence(text);
            Ok(Value::Null)
        }
        _ => Err(format!("System action '{}' not implemented", action)),
    }
}
