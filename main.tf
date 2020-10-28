#Create mgmt VPC
resource "google_compute_network" "mgmt-vpc" {
  name                    = var.mgmt_vpc_name
  auto_create_subnetworks = false
}
#Create datapath VPC
resource "google_compute_network" "datapath-vpc" {
  name                    = var.datapath_vpc_name
  auto_create_subnetworks = false
}

#Create egress VPC
resource "google_compute_network" "egress-vpc" {
  name                    = var.egress_vpc_name
  auto_create_subnetworks = false
}

#Create mgmt subnet
resource "google_compute_subnetwork" "mgmt-subnet" {
  name          = var.mgmt_subnet_name
  ip_cidr_range = var.mgmt_subnet_cidr
  region        = var.region
  network       = google_compute_network.mgmt-vpc.id
}

#Create datapath subnet
resource "google_compute_subnetwork" "datapath-subnet" {
  name          = var.datapath_subnet_name
  ip_cidr_range = var.datapath_subnet_cidr
  region        = var.region
  network       = google_compute_network.datapath-vpc.id
}

#Create datapath subnet
resource "google_compute_subnetwork" "egress-subnet" {
  name          = var.egress_subnet_name
  ip_cidr_range = var.egress_subnet_cidr
  region        = var.region
  network       = google_compute_network.egress-vpc.id
}

#Create mgmt firewall rule
resource "google_compute_firewall" "mgmt-firewall-rule" {
  name    = "${var.mgmt_vpc_name}-rule"
  network = var.mgmt_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  depends_on = [google_compute_network.mgmt-vpc]
}

#Create datapath firewall rule
resource "google_compute_firewall" "datapath-firewall-rule" {
  name    = "${var.datapath_vpc_name}-rule"
  network = var.datapath_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  depends_on = [google_compute_network.datapath-vpc
}

#Create egress firewall rule
resource "google_compute_firewall" "egress-firewall-rule" {
  name    = "${var.egress_vpc_name}-rule"
  network = var.egress_vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  depends_on = [google_compute_network.egress-vpc]
}