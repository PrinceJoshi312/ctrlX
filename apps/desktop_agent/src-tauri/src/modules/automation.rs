use playwright::Playwright;
use serde_json::Value;

pub async fn handle_browser(action: String, payload: Value) -> Result<Value, String> {
    let playwright = Playwright::initialize().await.map_err(|e| e.to_string())?;
    let browser_type = playwright.chromium();
    let browser = browser_type.launch().await.map_err(|e| e.to_string())?;
    let context = browser.context_builder().build().await.map_err(|e| e.to_string())?;
    let page = context.new_page().await.map_err(|e| e.to_string())?;

    match action.as_str() {
        "open_url" => {
            let url = payload["url"].as_str().ok_or("Missing URL")?;
            page.goto_builder(url).goto().await.map_err(|e| e.to_string())?;
            Ok(Value::Null)
        }
        "google_search" => {
            let query = payload["query"].as_str().ok_or("Missing query")?;
            page.goto_builder("https://www.google.com").goto().await.map_err(|e| e.to_string())?;
            page.fill("textarea[name='q']", query).await.map_err(|e| e.to_string())?;
            page.press("textarea[name='q']", "Enter").await.map_err(|e| e.to_string())?;
            Ok(Value::Null)
        }
        "youtube_search" => {
            let query = payload["query"].as_str().ok_or("Missing query")?;
            page.goto_builder("https://www.youtube.com").goto().await.map_err(|e| e.to_string())?;
            page.fill("input[name='search_query']", query).await.map_err(|e| e.to_string())?;
            page.press("input[name='search_query']", "Enter").await.map_err(|e| e.to_string())?;
            Ok(Value::Null)
        }
        "github_search" => {
            let query = payload["query"].as_str().ok_or("Missing query")?;
            let search_url = format!("https://github.com/search?q={}", query);
            page.goto_builder(&search_url).goto().await.map_err(|e| e.to_string())?;
            Ok(Value::Null)
        }
        _ => Err(format!("Browser action '{}' not implemented", action)),
    }
}
