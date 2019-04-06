locals {
  anywhere      = "0.0.0.0/0"
}

// https://confluence.rightnowtech.com/pages/viewpage.action?spaceKey=SECUR&title=OCNA+Subnets
resource "oci_core_security_list" "ocna" { 
  compartment_id = "${var.compartment_id}"
  display_name   = "ocna"
  vcn_id         = "${module.network.vcn_id}"

  ingress_security_rules = [
    { 
      source   = "160.34.86.0/23"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 22
        max = 22
      }
    },
    { 
      source   = "160.34.88.0/21"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 22
        max = 22
      }
    },
    { 
      source   = "160.34.104.0/21"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 22
        max = 22
      }
    },
    { 
      source   = "160.34.112.0/20"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 22
        max = 22
      }
    },
  ]
  egress_security_rules =  []
}

resource "oci_core_security_list" "natgw" { 
  compartment_id = "${var.compartment_id}"
  display_name   = "natgw"
  vcn_id         = "${module.network.vcn_id}"

  ingress_security_rules = []
  egress_security_rules = [
    // OCI Realm 1 IP Space
    { 
      destination = "192.29.0.0/16"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "147.154.0.0/16"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "138.1.0.0/16"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "130.35.0.0/16"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "134.70.0.0/17"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "140.91.0.0/17"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "192.29.0.0/16"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 8088
        max = 8088
      }
    },
    { 
      destination = "147.154.0.0/16"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 8088
        max = 8088
      }
    },
    { 
      destination = "138.1.0.0/16"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 8088
        max = 8088
      }
    },
    { 
      destination = "130.35.0.0/16"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 8088
        max = 8088
      }
    },
    { 
      destination = "134.70.0.0/17"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 8088
        max = 8088
      }
    },
    { 
      destination = "140.91.0.0/17"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 8088
        max = 8088
      }
    },
    // End OCI Realm 1 IP Space
    // OCI Auth (oke)
    { 
      destination = "130.61.0.142/32"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "130.61.2.138/32"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "130.61.4.138/32"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "129.213.0.145/32"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "129.146.14.134/32"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      destination = "132.145.2.139/32"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    // End OCI Auth
    // IDCS
    {
      protocol    = "${var.network_protocol["tcp"]}"
      destination = "${data.terraform_remote_state.common.idcs_server_cidrs[0]}"
 
      tcp_options {
        "min" = 443
        "max" = 443
      }
    },
    {
      protocol    = "${var.network_protocol["tcp"]}"
      destination = "${data.terraform_remote_state.common.idcs_server_cidrs[1]}"
 
      tcp_options {
        "min" = 443
        "max" = 443
      }
    },
    {
      protocol    = "${var.network_protocol["tcp"]}"
      destination = "${data.terraform_remote_state.common.idcs_server_cidrs[2]}"
 
      tcp_options {
        "min" = 443
        "max" = 443
      }
    },
    // End IDCS
    // OKE API Endpoints
    { 
      destination = "147.154.146.164/32"    // FRA
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 12250
        max = 12250
      }
    }, 
    { 
      destination = "147.154.146.164/32"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 6443
        max = 6443
      }
    }, 
    { 
      destination = "147.154.144.157/32"    // FRA
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 12250
        max = 12250
      }
    }, 
    { 
      destination = "147.154.144.157/32"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 6443
        max = 6443
      }
    }, 
    // Slack
    {
      destination = "13.33.144.134/32"
      protocol    = "${var.network_protocol["tcp"]}"

      tcp_options {
        min = 443
        max = 443
      }
    }
    // End Slack
  ]
}

resource "oci_core_security_list" "public" {
  compartment_id = "${var.compartment_id}"
  display_name   = "public"
  vcn_id         = "${module.network.vcn_id}"

  ingress_security_rules = [
    { 
      source   = "192.29.0.0/16"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      source   = "147.154.0.0/16"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      source   = "138.1.0.0/16"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      source   = "130.35.0.0/16"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      source   = "134.70.0.0/17"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      source   = "140.91.0.0/17"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    // OCNA https://confluence.rightnowtech.com/pages/viewpage.action?spaceKey=SECUR&title=OCNA+Subnets
    { 
      source   = "160.34.86.0/23"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      source   = "160.34.88.0/21"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      source   = "160.34.104.0/21"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    },
    { 
      source   = "160.34.112.0/20"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 443
        max = 443
      }
    }
    // End OCNA
  ]
  egress_security_rules = [
    { 
      destination = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"])}"
      protocol    = "${var.network_protocol["tcp"]}"
    },
    { 
      destination = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"] + 1)}"
      protocol    = "${var.network_protocol["tcp"]}"
    },
    { 
      destination = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"] + 2)}"
      protocol    = "${var.network_protocol["tcp"]}"
    },
  ]
}
resource "oci_core_security_list" "app" {
  compartment_id = "${var.compartment_id}"
  display_name   = "app"
  vcn_id         = "${module.network.vcn_id}"

  ingress_security_rules = [
    { 
      source   = "${var.virtual_network_cidr}"
      protocol = "${var.network_protocol["tcp"]}"
    },
    { 
      source   = "${var.virtual_network_cidr}"
      protocol = "${var.network_protocol["udp"]}"
    },
    {
      source   = "${data.terraform_remote_state.common.bastion_dmz_cidr}"
      protocol = "${var.network_protocol["tcp"]}"
    },
  ]
  egress_security_rules = [
    { 
      destination = "${var.virtual_network_cidr}"
      protocol    = "${var.network_protocol["tcp"]}"
    },
    { 
      destination = "${var.virtual_network_cidr}"
      protocol    = "${var.network_protocol["udp"]}"
    },
  ]
}

resource "oci_core_security_list" "data" {
  compartment_id = "${var.compartment_id}"
  display_name   = "data"
  vcn_id         = "${module.network.vcn_id}"

  ingress_security_rules = [
    { 
      source   = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"])}"
      protocol = "${var.network_protocol["tcp"]}"
    },
    { 
      source   = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"] + 1)}"
      protocol = "${var.network_protocol["tcp"]}"
    },
    { 
      source   = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"] + 2)}"
      protocol = "${var.network_protocol["tcp"]}"
    },
    {
      source   = "${cidrsubnet(var.virtual_network_cidr, local.newbits["data"], local.offsets["data"])}"
      protocol = "${var.network_protocol["tcp"]}"
    },
    {
      source   = "${data.terraform_remote_state.common.bastion_dmz_cidr}"
      protocol = "${var.network_protocol["tcp"]}"
    },
  ]
  egress_security_rules = [
    { 
      destination = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"])}"
      protocol    = "${var.network_protocol["tcp"]}"
    },
    { 
      destination = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"] + 1)}"
      protocol    = "${var.network_protocol["tcp"]}"
    },
    { 
      destination = "${cidrsubnet(var.virtual_network_cidr, local.newbits["app"], local.offsets["app"] + 2)}"
      protocol    = "${var.network_protocol["tcp"]}"
    },
    {
      destination = "${cidrsubnet(var.virtual_network_cidr, local.newbits["data"], local.offsets["data"])}"
      protocol    = "${var.network_protocol["tcp"]}"
    },
  ]
}
resource "oci_core_security_list" "global" {
  compartment_id = "${var.compartment_id}"
  display_name   = "global"
  vcn_id         = "${module.network.vcn_id}"

  ingress_security_rules = [
    { 
      source   = "${var.virtual_network_cidr}"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 22
        max = 22
      }
    },
    {
      source   = "${var.virtual_network_cidr}"
      protocol = "${var.network_protocol["icmp"]}"
    },
    { 
      source   = "${var.shared_vcn_cidr}"
      protocol = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 22
        max = 22
      }
    },
    {
      source   = "${var.shared_vcn_cidr}"
      protocol = "${var.network_protocol["icmp"]}"
    }
  ]
  egress_security_rules = [
    { 
      destination = "${var.virtual_network_cidr}"
      protocol    = "${var.network_protocol["tcp"]}"
 
      tcp_options {
        min = 22
        max = 22
      }
    },
    {
      destination = "${local.anywhere}"
      protocol    = "${var.network_protocol["icmp"]}"
    }
  ]
}
