use serde::Serialize;
use sysinfo::{System, SystemExt, CpuExt};
use std::time::Duration;

#[derive(Serialize)]
struct Metrics {
    node_name: String,
    cpu_usage: f32,
    ram_usage: u64,
}

#[tokio::main]
async fn main() {
    let mut sys = System::new_all();
    let client = reqwest::Client::new();

    println!("📡 Agent Aether démarré...");

    loop {
        sys.refresh_all();
        let cpu = sys.global_cpu_info().cpu_usage();
        let ram = sys.used_memory() / 1024 / 1024; // En Mo

        let payload = Metrics {
            node_name: "MacBook-2012".to_string(),
            cpu_usage: cpu,
            ram_usage: ram,
        };

        let _ = client.post("http://localhost:3000/ingest")
            .json(&payload)
            .send()
            .await;

        tokio::time::sleep(Duration::from_secs(5)).await;
    }
}
