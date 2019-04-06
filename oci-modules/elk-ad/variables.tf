variable client_instance_shape {}
variable client_instance_source_id {}
variable client_instance_tag_app {}
variable client_instance_tag_role {}

variable data_instance_shape {}
variable data_instance_source_id {}
variable data_instance_tag_app {}
variable data_instance_tag_role {}
variable data_instance_attach_volumes {
  default = false
}
variable data_instance_attach_volumes_size {
  default = 0
}

variable master_instance_shape {}
variable master_instance_source_id {}
variable master_instance_tag_app {}
variable master_instance_tag_role {}

variable kibana_instance_shape {}
variable kibana_instance_source_id {}
variable kibana_instance_tag_app {}
variable kibana_instance_tag_role {}

# Reused variables.
variable instance_ssh_key {}
variable instance_tag_envid {}
variable instance_tag_envtype {}
variable instance_tag_region {}
variable instance_tag_service {}
variable instance_tag_team {}
variable instance_tag_tenancy_name {}
variable instance_compartment_id {}
variable instance_requested_ad {}

variable "availability_domains" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}

variable instance_counts_by_ad {
  type = "map"
}