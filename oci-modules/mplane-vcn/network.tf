locals {
  newbits = { 
      app     = 3  // oke doesnt support regional subnets so we will use three /19s
      data    = 3  // regional /19
      public  = 8  // oke doesnt support regional subnets so we will use three /24s
  }
  offsets = { 
      app     = 0 
      data    = 3
      public  = 128
  }
}

module "network" {
  source             = "../../vcn-tf"
  vcn_cidr_block     = "${var.virtual_network_cidr}"
  vcn_compartment_id = "${var.compartment_id}"
  vcn_display_name   = "${var.virtual_network_display_name}"
  vcn_dns_label      = "${var.virtual_network_dns_label}"
}

resource "oci_core_nat_gateway" "gw" {
  compartment_id = "${var.compartment_id}"
  display_name   = "${var.virtual_network_display_name}"
  vcn_id         = "${module.network.vcn_id}"
}

resource "oci_core_route_table" "app" {
  compartment_id = "${var.compartment_id}"
  display_name   = "app"
  vcn_id         = "${module.network.vcn_id}"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      network_entity_id = "${oci_core_nat_gateway.gw.id}"
    },
    {
      destination       = "${data.terraform_remote_state.common.shared_vcn_cidr}"
      network_entity_id = "${oci_core_local_peering_gateway.mplane_to_shared.id}"
    }
  ]
}

resource "oci_core_route_table" "data" {
  compartment_id = "${var.compartment_id}"
  display_name   = "data"
  vcn_id         = "${module.network.vcn_id}"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      network_entity_id = "${oci_core_nat_gateway.gw.id}"
    },
    {
      destination       = "${data.terraform_remote_state.common.shared_vcn_cidr}"
      network_entity_id = "${oci_core_local_peering_gateway.mplane_to_shared.id}"
    }
  ]
}

resource "oci_core_route_table" "public" {
  compartment_id = "${var.compartment_id}"
  display_name   = "public"
  vcn_id         = "${module.network.vcn_id}"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      network_entity_id = "${module.network.vcn_default_igw}"
    },
    {
      destination       = "${data.terraform_remote_state.common.shared_vcn_cidr}"
      network_entity_id = "${oci_core_local_peering_gateway.mplane_to_shared.id}"
    }
  ]
}

resource "oci_core_subnet" "app" {
  count               = 3
  availability_domain = "${lookup(var.availability_domains[count.index],"name")}"
  compartment_id      = "${var.compartment_id}"
  display_name        = "${format("app%d", count.index)}"
  route_table_id      = "${oci_core_route_table.app.id}"
  vcn_id              = "${module.network.vcn_id}"

  security_list_ids = [
    "${oci_core_security_list.app.id}",
    "${oci_core_security_list.global.id}"
  ]

  dns_label    = "${format("app%d", count.index)}"
  cidr_block   = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"] + count.index)}"
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "data" {
  depends_on          = ["oci_core_subnet.app"]
  compartment_id      = "${var.compartment_id}"
  display_name        = "data"
  route_table_id      = "${oci_core_route_table.data.id}"
  vcn_id              = "${module.network.vcn_id}"

  security_list_ids = [
    "${oci_core_security_list.data.id}",
    "${oci_core_security_list.global.id}"
  ]

  dns_label    = "data"
  cidr_block   = "${cidrsubnet(var.virtual_network_cidr, local.newbits["data"], local.offsets["data"])}"
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "public" {
  count               = 3
  depends_on          = ["oci_core_subnet.data"]
  availability_domain = "${lookup(var.availability_domains[count.index],"name")}"
  compartment_id      = "${var.compartment_id}"
  display_name        = "${format("public%d", count.index)}"
  route_table_id      = "${oci_core_route_table.public.id}"
  vcn_id              = "${module.network.vcn_id}"

  security_list_ids = [
    "${oci_core_security_list.global.id}"
     ]

  dns_label    = "${format("public%d", count.index)}"
  cidr_block   = "${cidrsubnet(var.virtual_network_cidr, local.newbits["public"], local.offsets["public"] + count.index)}"
}

resource "oci_core_local_peering_gateway" "mplane_to_shared" {
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${module.network.vcn_id}"
  display_name   = "mplane-to-shared"
  peer_id        = "${data.terraform_remote_state.shared_network.shared_to_mplane_pgw_id}"
}
