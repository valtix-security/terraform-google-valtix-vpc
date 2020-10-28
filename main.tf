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
  source_tags = [var.mgmt_network_tag]
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
  source_tags = [var.datapath_network_tag]
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  depends_on = [google_compute_network.datapath-vpc]
}

#Create egress firewall rule
resource "google_compute_firewall" "egress-firewall-rule" {
  name    = "${var.egress_vpc_name}-rule"
  network = var.egress_vpc_name
  source_tags = [var.egress_network_tag]
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  depends_on = [google_compute_network.egress-vpc]
}

#create VPC peering connection from datapath to egress
resource "google_compute_network_peering" "datapath-to-egress" {
  name         = "${var.datapath_vpc_name}-to-${var.egress_vpc_name}"
  network      = google_compute_network.datapath-vpc.id
  peer_network = google_compute_network.egress-vpc.id
  import_custom_routes = "true"
}

#create VPC peering connection from egress to datapath
resource "google_compute_network_peering" "egress-to-datapath" {
  name         = "${var.egress_vpc_name}-to-${var.datapath_vpc_name}"
  network      = google_compute_network.egress-vpc.id
  peer_network = google_compute_network.datapath-vpc.id
  export_custom_routes = "true"
}