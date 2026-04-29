use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::fs;
use std::path::PathBuf;
use super::handlers::{CommandRequest, dispatch};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Workflow {
    pub name: String,
    pub description: String,
    pub commands: Vec<Value>, // Raw command payloads to be parsed by dispatcher
}

pub async fn handle_workflow(action: String, payload: Value) -> Result<Value, String> {
    match action.as_str() {
        "run" => {
            let name = payload["name"].as_str().ok_or("Missing workflow name")?;
            run_workflow(name).await
        }
        "save" => {
            let workflow: Workflow = serde_json::from_value(payload).map_err(|e| e.to_string())?;
            save_workflow(workflow).map_err(|e| e.to_string())?;
            Ok(Value::Null)
        }
        _ => Err(format!("Workflow action '{}' not implemented", action)),
    }
}

pub async fn run_workflow(name: &str) -> Result<Value, String> {
    let workflow = load_workflow(name)?;
    println!("[Workflow] Running: {}", workflow.name);

    for cmd_val in workflow.commands {
        if let Ok(req) = serde_json::from_value::<CommandRequest>(cmd_val) {
            dispatch(req).await;
        }
    }

    Ok(serde_json::json!({"status": "completed", "workflow": name}))
}

pub fn save_workflow(workflow: Workflow) -> Result<(), String> {
    let path = get_workflow_path(&workflow.name);
    let json = serde_json::to_string_pretty(&workflow).map_err(|e| e.to_string())?;
    fs::write(path, json).map_err(|e| e.to_string())?;
    Ok(())
}

fn load_workflow(name: &str) -> Result<Workflow, String> {
    let path = get_workflow_path(name);
    let data = fs::read_to_string(path).map_err(|_| format!("Workflow '{}' not found", name))?;
    serde_json::from_str(&data).map_err(|e| e.to_string())
}

fn get_workflow_path(name: &str) -> PathBuf {
    let mut path = std::env::current_dir().unwrap();
    path.push("workflows");
    if !path.exists() { fs::create_dir_all(&path).ok(); }
    path.push(format!("{}.json", name));
    path
}
