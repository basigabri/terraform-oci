locals {
  availability_domain  = "${var.availability_domains[var.instance_requested_ad - 1]}"
  instance_name_suffix = "${format("%s-%s-%s-ad%s", var.instance_tag_tenancy_name, var.instance_tag_envtype, var.instance_tag_region, var.instance_requested_ad)}"
  subnet_id            = "${var.subnet_ids[var.instance_requested_ad - 1]}"

  data_instance_counts = "${var.instance_counts_by_ad[format("ad%s.data", var.instance_requested_ad)]}"
}

resource "oci_core_instance" "es_client" {
  count               = "${var.instance_counts_by_ad[format("ad%s.client", var.instance_requested_ad)]}"
  availability_domain = "${lookup(local.availability_domain, "name")}"
  compartment_id      = "${var.instance_compartment_id}"
  display_name        = "${format("esclient-%d-%s", count.index, local.instance_name_suffix)}"
  shape               = "${var.client_instance_shape}"
  subnet_id           = "${local.subnet_id}"

  source_details {
    source_id   = "${var.client_instance_source_id}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.instance_ssh_key}"
  }

  freeform_tags {
    ad          = "${lookup(local.availability_domain, "name")}"
    app         = "${var.client_instance_tag_app}"
    envid       = "${var.instance_tag_envid}"
    envtype     = "${var.instance_tag_envtype}"
    region      = "${var.instance_tag_region}"
    role        = "${var.client_instance_tag_role}"
    service     = "${var.instance_tag_service}"
    team        = "${var.instance_tag_team}"
    tenancy     = "${var.instance_tag_tenancy_name}"
  }
}

resource "oci_core_instance" "es_data" {
  count               = "${local.data_instance_counts}"
  availability_domain = "${lookup(local.availability_domain, "name")}"
  compartment_id      = "${var.instance_compartment_id}"
  display_name        = "${format("esdata-%d-%s", count.index, local.instance_name_suffix)}"
  shape               = "${var.data_instance_shape}"
  subnet_id           = "${local.subnet_id}"

  source_details {
    source_id   = "${var.data_instance_source_id}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.instance_ssh_key}"
  }

  freeform_tags {
    ad          = "${lookup(local.availability_domain, "name")}"
    app         = "${var.data_instance_tag_app}"
    envid       = "${var.instance_tag_envid}"
    envtype     = "${var.instance_tag_envtype}"
    region      = "${var.instance_tag_region}"
    role        = "${var.data_instance_tag_role}"
    service     = "${var.instance_tag_service}"
    team        = "${var.instance_tag_team}"
    tenancy     = "${var.instance_tag_tenancy_name}"
  }
}

resource "oci_core_volume" "es_data_volume" {
  count               = "${var.data_instance_attach_volumes ? local.data_instance_counts : 0}"
  availability_domain = "${lookup(local.availability_domain, "name")}"
  compartment_id      = "${var.instance_compartment_id}"
  size_in_gbs         = "${var.data_instance_attach_volumes_size}"
}

resource "oci_core_volume_attachment" "es_data_volume_attachment" {
  count           = "${var.data_instance_attach_volumes ? local.data_instance_counts : 0}"
  attachment_type = "iscsi"
  compartment_id  = "${var.instance_compartment_id}"
  instance_id     = "${element(oci_core_instance.es_data.*.id, count.index)}"
  volume_id       = "${element(oci_core_volume.es_data_volume.*.id, count.index)}"
}

resource "oci_core_instance" "es_master" {
  count               = "${var.instance_counts_by_ad[format("ad%s.master", var.instance_requested_ad)]}"
  availability_domain = "${lookup(local.availability_domain,"name")}"
  compartment_id      = "${var.instance_compartment_id}"
  display_name        = "${format("esmaster-%d-%s", count.index, local.instance_name_suffix)}"
  shape               = "${var.master_instance_shape}"
  subnet_id           = "${local.subnet_id}"

  source_details {
    source_id   = "${var.master_instance_source_id}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.instance_ssh_key}"
  }

  freeform_tags {
    ad          = "${lookup(local.availability_domain, "name")}"
    app         = "${var.master_instance_tag_app}"
    envid       = "${var.instance_tag_envid}"
    envtype     = "${var.instance_tag_envtype}"
    region      = "${var.instance_tag_region}"
    role        = "${var.master_instance_tag_role}"
    service     = "${var.instance_tag_service}"
    team        = "${var.instance_tag_team}"
    tenancy     = "${var.instance_tag_tenancy_name}"
  }
}

resource "oci_core_instance" "kibana" {
  count               = "${var.instance_counts_by_ad[format("ad%s.kibana", var.instance_requested_ad)]}"
  availability_domain = "${lookup(local.availability_domain, "name")}"
  compartment_id      = "${var.instance_compartment_id}"
  display_name        = "${format("kibana-%d-%s", count.index, local.instance_name_suffix)}"
  shape               = "${var.kibana_instance_shape}"
  subnet_id           = "${local.subnet_id}"

  source_details {
    source_id   = "${var.kibana_instance_source_id}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.instance_ssh_key}"
  }

  freeform_tags {
    ad          = "${lookup(local.availability_domain, "name")}"
    app         = "${var.kibana_instance_tag_app}"
    envid       = "${var.instance_tag_envid}"
    envtype     = "${var.instance_tag_envtype}"
    region      = "${var.instance_tag_region}"
    role        = "${var.kibana_instance_tag_role}"
    service     = "${var.instance_tag_service}"
    team        = "${var.instance_tag_team}"
    tenancy     = "${var.instance_tag_tenancy_name}"
  }
}