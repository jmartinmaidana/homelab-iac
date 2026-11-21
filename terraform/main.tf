terraform {
  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.17"
    }
  }
}

provider "tailscale" {}

resource "tailscale_acl" "politica_homelab" {
  acl = jsonencode({
    tagOwners = {
      (var.client_tag) = ["autogroup:admin"]
    }

    grants = [
      {
        src = ["autogroup:member"]
        dst = ["*"]
        ip  = ["*"]
      },
      {
        src = [var.client_tag]
        dst = [var.jellyfin_server_tailscale_ip]
        ip  = ["tcp:${var.jellyfin_port}"]
      }
    ]

    ssh = [
      {
        action = "check"
        src    = ["autogroup:member"]
        dst    = ["autogroup:self"]
        users  = ["autogroup:nonroot", "root"]
      }
    ]

    nodeAttrs = [
      {
        target = ["autogroup:member"]
        attr   = ["funnel"]
      }
    ]
  })
}

# Genera automáticamente una AuthKey reutilizable y preautorizada con la etiqueta del cliente
resource "tailscale_tailnet_key" "cliente_app_key" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
  expiry        = 7776000 # 90 días (máximo permitido por Tailscale)
  tags          = [var.client_tag]

  depends_on = [tailscale_acl.politica_homelab]
}

output "client_auth_key" {
  description = "Clave de autenticación para inyectar en el cliente Go (TAILSCALE_AUTH_KEY)"
  value       = tailscale_tailnet_key.cliente_app_key.key
  sensitive   = true
}


