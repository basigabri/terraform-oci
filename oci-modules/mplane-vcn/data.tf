data "terraform_remote_state" "common" {
  backend = "artifactory"
 
  config {
    username = "${var.user}"
    url      = "https://${var.artifactory_url}/"
    repo     = "${var.repository}"
    subpath  = "oci/${var.tenancy_name}/common"
  }
}

data "terraform_remote_state" "shared_network" {
  backend = "artifactory"
 
  config {
    username = "${var.user}"
    url      = "https://${var.artifactory_url}/"
    repo     = "${var.repository}"
    subpath  = "oci/${var.tenancy_name}/${var.region_name}/network"
  }
}

data "oci_identity_availability_domains" "ad" {
  compartment_id = "${var.tenancy_ocid}"
}