provider "google"{
    project = "polytech"
    region = "europe-west1"
    zone = "europe-west-1-b"
    credentials = file("student.json")
}

resource "google_compute_network" "vpc_network" {
    name = "vpc-network"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
    name = "vpc-subnetwork"
    ip_cidr_range = "192.168.1.0/24"
    network = google_compute_network.vpc_network.name
}

resource "google_compute_instance" "server_instance" {
    name = "polytech-server"
    machine_type = "n2-standard-2"

    network_interface {
      network = google_compute_subnetwork.vpc_subnetwork.name
      network_ip = "192.168.1.1/24"

      access_config {
        nat_ip = "192.168.1.1/24"
      }
    }

    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-12"
      }
    }
}

resource "google_sql_database_instance" "database_instance" {
    name = "database-instance"
    database_version = "POSTGRES_15"

    settings {
      tier = "db-f1-micro"
    }
}

resource "google_sql_database" "database" {
    name = "database"
    instance = google_sql_database_instance.database_instance.name
}