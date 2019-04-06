variable "prom_instance_counts" {
  default = {
    "ad1.prom" = 1
    "ad2.prom" = 1
    "ad3.prom" = 1
  }
}
variable "prom_tenancy_name" {
  default = "mplane"
}

module "prom_ad1" {
  source = "oci-modules/prometheus/"
  dyn_zone = "${var.dyn_zone}"
  dyn_suffix = "${var.dyn_suffix}"

  prom_instance_shape = "${var.shapes["2.8"]}"
  prom_instance_source_id = "${var.ssvcs-1-7-01-OEL7u5}"
  prom_instance_attach_volumes = false
  prom_instance_attach_volumes_size = 0

  instance_tag_app = "${var.tags_app["prometheus"]}"
  instance_tag_role = "${var.tags_role["mplane-monitoring"]}"
  instance_tag_envid = "${var.tags_envid}"
  instance_tag_envtype = "${var.tags_envtype}"
  instance_tag_region = "${var.tags_region}"
  instance_tag_service = "${var.tags_service}"
  instance_tag_team = "${var.tags_team}"
  instance_tag_tenancy_name = "${var.prom_tenancy_name}"
  instance_ssh_key = "${var.all_mplane_public_key}"
  instance_compartment_id = "${data.terraform_remote_state.common.elk_compartment}"

  instance_requested_ad = 1
  instance_counts_by_ad = "${var.prom_instance_counts}"

  availability_domains = "${data.oci_identity_availability_domains.ad.availability_domains}"
  subnet_ids = "${module.mplanesvc_vcn.private_subnet_ids}"
}

module "prom_ad2" {
  source = "../../common/modules/elk_compartment/prometheus/"
  dyn_zone = "${var.dyn_zone}"
  dyn_suffix = "${var.dyn_suffix}"

  prom_instance_shape = "${var.shapes["2.8"]}"
  prom_instance_source_id = "${var.ssvcs-1-7-01-OEL7u5}"
  prom_instance_attach_volumes = false
  prom_instance_attach_volumes_size = 0

  instance_tag_app = "${var.tags_app["prometheus"]}"
  instance_tag_role = "${var.tags_role["mplane-monitoring"]}"
  instance_tag_envid = "${var.tags_envid}"
  instance_tag_envtype = "${var.tags_envtype}"
  instance_tag_region = "${var.tags_region}"
  instance_tag_service = "${var.tags_service}"
  instance_tag_team = "${var.tags_team}"
  instance_tag_tenancy_name = "${var.prom_tenancy_name}"
  instance_ssh_key = "${var.all_mplane_public_key}"
  instance_compartment_id = "${data.terraform_remote_state.common.elk_compartment}"

  instance_requested_ad = 2
  instance_counts_by_ad = "${var.prom_instance_counts}"

  availability_domains = "${data.oci_identity_availability_domains.ad.availability_domains}"
  subnet_ids = "${module.mplanesvc_vcn.private_subnet_ids}"
}

module "prom_ad3" {
  source = "../../common/modules/elk_compartment/prometheus/"
  dyn_zone = "${var.dyn_zone}"
  dyn_suffix = "${var.dyn_suffix}"

  prom_instance_shape = "${var.shapes["2.8"]}"
  prom_instance_source_id = "${var.ssvcs-1-7-01-OEL7u5}"
  prom_instance_attach_volumes = false
  prom_instance_attach_volumes_size = 0

  instance_tag_app = "${var.tags_app["prometheus"]}"
  instance_tag_role = "${var.tags_role["mplane-monitoring"]}"
  instance_tag_envid = "${var.tags_envid}"
  instance_tag_envtype = "${var.tags_envtype}"
  instance_tag_region = "${var.tags_region}"
  instance_tag_service = "${var.tags_service}"
  instance_tag_team = "${var.tags_team}"
  instance_tag_tenancy_name = "${var.prom_tenancy_name}"
  instance_ssh_key = "${var.all_mplane_public_key}"
  instance_compartment_id = "${data.terraform_remote_state.common.elk_compartment}"

  instance_requested_ad = 3
  instance_counts_by_ad = "${var.prom_instance_counts}"
  
  availability_domains = "${data.oci_identity_availability_domains.ad.availability_domains}"
  subnet_ids = "${module.mplanesvc_vcn.private_subnet_ids}"
}

resource "oci_core_volume" "prometheus" {
  count               = "${var.num_prometheus_instances}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index % 3], "name")}"
  compartment_id      = "${data.terraform_remote_state.common.elk_compartment}"
  size_in_gbs         = "${var.block_size["prometheus-disk"]}"
}
