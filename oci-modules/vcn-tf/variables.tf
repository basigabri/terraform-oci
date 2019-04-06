// CIDR to use to build the VCN
variable "vcn_cidr_block" {}

// compartment ID where the VCN is to be created
variable "vcn_compartment_id" {}

// display name for the VCN. Other items will use this as a base name
variable "vcn_display_name" {}

// DNS label for the VCN. Even if DNS isn't enabled
variable "vcn_dns_label" {}
