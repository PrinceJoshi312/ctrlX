use socketioxide::extract::{Data, SocketRef};
use serde_json::Value;
use mdns_sd::{ServiceInfo, ServiceDaemon};
use rand::RRect; // Note: simplified for placeholder logic
use std::collections::HashMap;

pub async fn start_server() -> Result<(), Box<dyn std::error::Error>> {
    let (layer, io) = socketioxide::SocketIo::builder().build_layer();
    
    // Simple in-memory pairing store
    let pairing_code = "1234"; // Fixed for demo, would be random in prod
    println!("--- PAIRING CODE: {} ---", pairing_code);

    io.ns("/", move |socket: SocketRef| {
        socket.on("pair", move |socket: SocketRef, Data::<Value>(data)| {
            let submitted_code = data["code"].as_str().unwrap_or("");
            let provided_token = data["token"].as_str().unwrap_or("");

            if submitted_code == pairing_code || super::settings::is_trusted(provided_token) {
                let token = if provided_token.is_empty() { "dummy_token_123".to_string() } else { provided_token.to_string() };
                super::settings::save_token(token.clone());
                socket.extensions.insert("is_paired".to_string());
                socket.emit("pair_result", serde_json::json!({"success": true, "token": token})).ok();
            } else {
                socket.emit("pair_result", serde_json::json!({"success": false})).ok();
            }
        });

        socket.on("command", move |socket: SocketRef, Data::<Value>(data)| {
            // Check Authorization
            if socket.extensions.get::<String>().is_none() {
                socket.emit("command_response", serde_json::json!({
                    "status": "failure",
                    "error": "Unauthorized: Device not paired"
                })).ok();
                return;
            }

            // Validate and Parse
            match serde_json::from_value::<super::handlers::CommandRequest>(data) {
                Ok(req) => {
                    tokio::spawn(async move {
                        let response = super::handlers::dispatch(req).await;
                        socket.emit("command_response", response).ok();
                    });
                }
                Err(e) => {
                    eprintln!("Malformed command received: {}", e);
                    socket.emit("command_response", serde_json::json!({
                        "status": "failure",
                        "error": format!("Invalid command format: {}", e)
                    })).ok();
                }
            }
        });

        socket.on("ping", |socket: SocketRef, Data::<Value>(data)| {
            socket.emit("pong", serde_json::json!({ "timestamp": chrono::Utc::now().to_rfc3339() })).ok();
        });
    });

    // Start mDNS Advertising
    let mdns = ServiceDaemon::new()?;
    let service_type = "_ctrlx._tcp.local.";
    let instance_name = "ctrlx_agent";
    let port = 3000;
    let my_service = ServiceInfo::new(
        service_type,
        instance_name,
        "ctrlx_agent.local.",
        "", 
        port,
        None,
    )?;
    mdns.register(my_service)?;
    println!("mDNS Advertising started: _ctrlx._tcp.local");

    let app = axum::Router::new().layer(layer).layer(tower_http::cors::CorsLayer::permissive());
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    axum::serve(listener, app).await?;
    Ok(())
}
