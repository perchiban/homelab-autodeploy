terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://10.10.0.252:8006/api2/json"
    pm_api_token_secret = "55b32ef1-9e46-4ace-879f-b012ec548230"
    pm_api_token_id = "terraform@pve!terraform-token"
}
