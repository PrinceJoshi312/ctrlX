mod system;
mod input;
mod agent;

use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Deserialize)]
pub struct CommandRequest {
    pub id: String,
    pub category: String,
    pub action: String,
    pub payload: Value,
}

#[derive(Serialize)]
pub struct CommandResponse {
    pub request_id: String,
    pub status: String,
    pub data: Value,
    pub error: Option<String>,
}

pub async fn dispatch(req: CommandRequest) -> CommandResponse {
    println!("[Dispatcher] Routing Category: {}", req.category);

    let result = match req.category.as_str() {
        "system" => system::handle(req.action, req.payload).await,
        "input" => input::handle(req.action, req.payload).await,
        "agent" => agent::handle(req.action, req.payload).await,
        "browser" => super::automation::handle_browser(req.action, req.payload).await,
        "workflow" => super::workflows::handle_workflow(req.action, req.payload).await,
        _ => Err(format!("Unknown category: {}", req.category)),
    };

    match result {
        Ok(data) => CommandResponse { request_id: req.id, status: "success".into(), data, error: None },
        Err(e) => CommandResponse { request_id: req.id, status: "failure".into(), data: Value::Null, error: Some(e) },
    }
}
