variable "mgmt_subnet_cidr" {
  description = "CIDR block of the mgmt VPC for Valtix Gateway"
}

variable "datapath_subnet_cidr" {
  description = "CIDR block of the datapath VPC for Valtix Gateway"
}

variable "egress_subnet_cidr" {
  description = "CIDR block of the egress VPC for Valtix Gateway"
}

variable "mgmt_vpc_name" {
  description = "name of management vpc"
  default     = "mgmt-vpc"
}

variable "datapath_vpc_name" {
  description = "name of datapath vpc"
  default     = "datapath-vpc"
}

variable "egress_vpc_name" {
  description = "name of egress vpc"
  default     = "egress-vpc"
}

variable "mgmt_subnet_name" {
  description = "name of management subnet"
  default     = "mgmt-subnet"
}

variable "datapath_subnet_name" {
  description = "name of datapath subnet"
  default     = "datapath-subnet"
}

variable "egress_subnet_name" {
  description = "name of egress subnet"
  default     = "egress-subnet"
}

variable "region" {
  description = "region where Google Cloujd VPC subnet gets deployed"
}

variable "mgmt_network_tag" {
  description = "network tag for firewall rules for mgmt interfaces"
  default = "valtix-mgmt"
}

variable "datapath_network_tag" {
  description = "network tag for firewall rules for datapath interface for Valtix gateway"
  default = "valtix-datapath"
}

variable "egress_network_tag" {
  description = "network tag for firewall rules for egress gateway datapath interface"
  default = "valtix-egress"
}
