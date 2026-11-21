variable "jellyfin_server_tailscale_ip" {
  description = "IP fija de Tailscale asignada al servidor Jellyfin"
  type        = string
}

variable "client_tag" {
  description = "Etiqueta asignada a los dispositivos clientes de la aplicación"
  type        = string
  default     = "tag:jellyfin-app"
}

variable "jellyfin_port" {
  description = "Puerto TCP donde escucha el servidor Jellyfin"
  type        = string
  default     = "8096"
}
