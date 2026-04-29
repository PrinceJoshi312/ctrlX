use serde::{Deserialize, Serialize};
use std::fs;
use std::collections::HashSet;

#[derive(Serialize, Deserialize, Default)]
pub struct Config {
    pub trusted_tokens: HashSet<String>,
}

pub fn save_token(token: String) {
    let mut config = load_config();
    config.trusted_tokens.insert(token);
    let json = serde_json::to_string(&config).unwrap();
    fs::write("agent_config.json", json).ok();
}

pub fn is_trusted(token: &str) -> bool {
    load_config().trusted_tokens.contains(token)
}

fn load_config() -> Config {
    if let Ok(data) = fs::read_to_string("agent_config.json") {
        return serde_json::from_str(&data).unwrap_or_default();
    }
    Config::default()
}
