mod modules;

use tauri::{CustomMenuItem, SystemTray, SystemTrayMenu, SystemTrayMenuItem, SystemTrayEvent, Manager};

#[tokio::main]
async fn main() {
  // Setup System Tray
  let quit = CustomMenuItem::new("quit".to_string(), "Quit CtrlX");
  let hide = CustomMenuItem::new("hide".to_string(), "Hide Window");
  let tray_menu = SystemTrayMenu::new()
    .add_item(quit)
    .add_native_item(SystemTrayMenuItem::Separator)
    .add_item(hide);

  let system_tray = SystemTray::new().with_menu(tray_menu);

  // Spawn the Socket.IO server
  tokio::spawn(async {
    if let Err(e) = modules::transport::start_server().await {
      eprintln!("Failed to start transport server: {}", e);
    }
  });

  tauri::Builder::default()
    .system_tray(system_tray)
    .on_system_tray_event(|app, event| match event {
      SystemTrayEvent::MenuItemClick { id, .. } => {
        match id.as_str() {
          "quit" => std::process::exit(0),
          "hide" => {
            let window = app.get_window("main").unwrap();
            window.hide().unwrap();
          }
          _ => {}
        }
      }
      _ => {}
    })
    .on_window_event(|event| match event.event() {
      tauri::WindowEvent::CloseRequested { api, .. } => {
        event.window().hide().unwrap();
        api.prevent_close();
      }
      _ => {}
    })
    .invoke_handler(tauri::generate_handler![])
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}
