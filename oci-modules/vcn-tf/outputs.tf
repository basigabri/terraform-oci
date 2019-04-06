// use default route for edge instances for 0.0.0.0/0
output "vcn_default_route" {
  value = "${oci_core_vcn.vcn.default_route_table_id}"
}

// default DHCP options
output "vcn_default_dhcp_options" {
  value = "${oci_core_vcn.vcn.default_dhcp_options_id}"
}

// the OCID of the VCN that was created
output "vcn_id" {
  value = "${oci_core_vcn.vcn.id}"
}

output "vcn_dhcp_id" {
  value = "${oci_core_dhcp_options.vcn.id}"
}

// default route table for VCN that is actually configured
output "vcn_default_route_table" {
  value = "${oci_core_route_table.vcn.id}"
}

// default internet gateway for the VCN
output "vcn_default_igw" {
  value = "${oci_core_internet_gateway.vcn.id}"
}
