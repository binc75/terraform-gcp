# Google compute instance setup
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  # SSH key from localhost
  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  # OS image
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
	# Specific network interpolation
	network = google_compute_network.vpc_network.self_link
    access_config {
       ## Ephemeral IP
    }
  }
}

# Dedicated VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}

# Firewall rule to allow ssh incoming traffic
resource "google_compute_firewall" "default" {
 name    = "allow-ssh"
 network = google_compute_network.vpc_network.self_link

 allow {
   protocol = "tcp"
   ports    = ["22"]
 }
}
