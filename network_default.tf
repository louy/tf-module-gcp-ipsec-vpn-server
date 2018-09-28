data google_compute_network default {
  name = "${var.network_name}"
}

data google_compute_subnetwork default {
  name   = "${var.subnetwork_name}"
  region = "${var.subnetwork_region}"
}
