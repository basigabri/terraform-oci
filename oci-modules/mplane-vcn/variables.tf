variable public_keys {}
variable compartment_id {}
variable shared_vcn_cidr {}
variable virtual_network_cidr {}
variable tenancy_name {}
variable tenancy_ocid {}
variable region_name {}

variable virtual_network_display_name {
  default = "mPlane"
}
variable virtual_network_dns_label {
  default = "mplane"
}

variable oke_cluster_name {
  default = "mplane"
}
variable oke_dashboard_enabled {
  default = true
}

variable oke_tiller_enabled {
  default = true
}

variable oke_pods_cidr {
  default = "10.244.0.0/16"
}

variable oke_services_cidr { 
  default = "10.96.0.0/16"
}

variable "availability_domains" {
  type = "list"
}

variable shared_vcn_peer_id { 
  default = ""
}
variable "network_protocol" {
  default = {
    "tcp"  = "6"
    "icmp" = "1"
    "udp"  = "17"
  }
}
