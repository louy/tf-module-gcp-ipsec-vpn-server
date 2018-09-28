variable project {}

variable network_name {
  default = "default"
}

variable subnetwork_name {
  default = "default"
}

variable subnetwork_region {
  default = "europe-west2"
}

variable server_zone {
  default = "europe-west2-b"
}

variable vpn_psk {}
variable vpn_username {}
variable vpn_password {}

variable vpn_static_ip {}

variable ip_address_whitelist {
  type = "list"
}
