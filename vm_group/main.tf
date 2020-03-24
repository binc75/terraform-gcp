# Terraform requirements
terraform {
  required_version = "> 0.12.12"
}


# Create a compute instance template
resource "google_compute_instance_template" "vm-template" {
  name_prefix = "vm-template-"
  tags = ["foo", "webserver", "vm-instance"]


  machine_type = "f1-micro"
  region       = var.region

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
    auto_delete = true
    boot = true
    disk_size_gb = "11"
  }

  network_interface {
    network = "vpc-net"
    access_config {
      ## Ephemeral IP to allow machine to nagivate 
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  # SSH key from localhost
  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  metadata_startup_script = file("startup.sh")
}

# Create a google_compute_region_instance_group_manager
resource "google_compute_region_instance_group_manager" "igm" {
  name               = substr("igm-${md5(google_compute_instance_template.vm-template.name)}", 0, 63)
  base_instance_name = "vm-instance"
  region             = var.region
  target_size        = 3
  wait_for_instances = true

  version {
    instance_template = google_compute_instance_template.vm-template.self_link
  }

  timeouts {
    create = "10m"
    update = "10m"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Define network
resource "google_compute_network" "vpc-net" {
  name = "vpc-net"
  auto_create_subnetworks = "true"
}

## Firewall rule to allow ssh incoming traffic
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc-net.self_link
 
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["vm-instance"]
}

# Firewall rule to allow http incoming traffic
resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.vpc-net.self_link
 
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["webserver"]
}

