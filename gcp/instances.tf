provider "google" {
  project     = "peaceful-tide-385904"
  region      = "us-central1"
  credentials = "./server-account.json"
}
resource "google_compute_instance" "default" {
  count = 2
  name         = "k0scluster-${count.index}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230605"
      size = "20"
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}
output "public_ip" {
  value = [for instance in google_compute_instance.default : instance.network_interface[0].access_config[0].nat_ip]
}
