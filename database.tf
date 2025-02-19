resource "google_sql_database_instance" "default" {
  name             = "my-db-instance"
  region           = "us-central1"

  database_version = "MYSQL_5_7"  # Choose the version you need

  settings {
    tier = "db-f1-micro"  # Change the machine type as needed
    backup_configuration {
      enabled = true
    }
    ip_configuration {
      authorized_networks {
        name  = "my-network"
        value = "0.0.0.0/0"  # You can restrict this to a specific IP
      }
      ipv4_enabled = true
    }
  }
}

resource "google_sql_database" "my_database" {
  name     = "mydatabase"
  instance = google_sql_database_instance.default.name
}

resource "google_sql_user" "default" {
  name     = "admin"
  instance = google_sql_database_instance.default.name
  password = "securepassword123"
}

resource "google_compute_firewall" "default" {
  name    = "default-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}
