resource google_compute_instance ipsec-vpn-server {
  name         = "ipsec-vpn-server"
  machine_type = "n1-standard-1"
  zone         = "${var.server_zone}"
  tags         = ["trusted-ipsec-vpn"]

  boot_disk {
    initialize_params {
      image = "//www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20180911"
      type  = "pd-standard"
      size  = 10
    }
  }

  metadata_startup_script = "wget https://git.io/vpnsetup -O vpnsetup.sh && sudo \\\nVPN_IPSEC_PSK='${var.vpn_psk}' \\\nVPN_USER='${var.vpn_user}' \\\nVPN_PASSWORD='${var.vpn_password}' sh vpnsetup.sh"

  network_interface {
    subnetwork = "${google_compute_subnetwork.default.self_link}"

    access_config {
      nat_ip = "${var.vpn_static_ip}"
    }
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
  }
}

resource google_compute_firewall allow_trusted_ipsec_vpn {
  name        = "allow-trusted-ipsec-vpn"
  network     = "${google_compute_network.wtr-promo-vn.name}"
  description = "Allow IPSec VPN traffic from trusted sources"

  source_ranges = ["${var.ip_address_whitelist}"]

  allow {
    protocol = "tcp"
    ports    = ["500"]
  }

  allow {
    protocol = "udp"
    ports    = ["500", "4500"]
  }

  target_tags = ["trusted-ipsec-vpn"]
}
