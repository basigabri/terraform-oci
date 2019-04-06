variable "instance_name" {}
variable "instance_count" {}
variable "instance_shape" {}
variable "instance_source_id" {}
variable "instance_authorized_key" {}
variable "instance_compartment_id" {}

variable "instance_tag_app" {}
variable "instance_tag_team" {}
variable "instance_tag_envid" {}
variable "instance_tag_region" {}
variable "instance_tag_envtype" {}
variable "instance_tag_service" {}

variable "instance_volume_size" { 
  default = 0 
}

variable "region" {} 

variable "availability_domains" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}
variable "dyn_suffix" {}

variable "dyn_zone" {}
