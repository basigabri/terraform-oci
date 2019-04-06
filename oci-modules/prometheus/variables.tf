variable prom_instance_shape {}
variable prom_instance_source_id {}
variable prom_instance_attach_volumes {
  default = false
}
variable prom_instance_attach_volumes_size {
  default = 0
}
# Reused variables.
variable instance_ssh_key {}
variable instance_tag_app {}
variable instance_tag_role {}
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
variable "dyn_suffix" {}

variable "dyn_zone" {}