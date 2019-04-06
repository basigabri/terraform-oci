resource "oci_core_vcn" "vcn" {
  cidr_block     = "${var.vcn_cidr_block}"
  compartment_id = "${var.vcn_compartment_id}"
  display_name   = "${var.vcn_display_name}"
  dns_label      = "${var.vcn_dns_label}"
}

resource "oci_core_internet_gateway" "vcn" {
  depends_on     = ["oci_core_vcn.vcn"]
  compartment_id = "${var.vcn_compartment_id}"
  display_name   = "${format("%s-igw", var.vcn_display_name)}"
  vcn_id         = "${oci_core_vcn.vcn.id}"
}

// route all things to outside world unless specifically overridden
// somewhere else.
resource "oci_core_route_table" "vcn" {
  depends_on     = ["oci_core_internet_gateway.vcn"]
  compartment_id = "${var.vcn_compartment_id}"
  display_name   = "${format("%s-default-route", var.vcn_display_name)}"
  vcn_id         = "${oci_core_vcn.vcn.id}"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.vcn.id}"
  }
}

resource "oci_core_dhcp_options" "vcn" {
  depends_on     = ["oci_core_vcn.vcn"]
  compartment_id = "${var.vcn_compartment_id}"
  vcn_id         = "${oci_core_vcn.vcn.id}"
  display_name   = "${format("%s-dhcp-options", var.vcn_display_name)}"

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["${format("%s.oraclevcn.com", var.vcn_dns_label)}"]
  }
}
