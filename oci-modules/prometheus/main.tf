locals {
  availability_domain  = "${var.availability_domains[var.instance_requested_ad - 1]}"
  instance_name_suffix = "${format("%s-%s-%s-ad%s", var.instance_tag_tenancy_name, var.instance_tag_envtype, var.instance_tag_region, var.instance_requested_ad)}"

  subnet_id            = "${var.subnet_ids[var.instance_requested_ad - 1]}"
  prom_instance_counts = "${var.instance_counts_by_ad[format("ad%s.prom", var.instance_requested_ad)]}"
  
}

resource "oci_core_instance" "prometheus" {
  count               = "${local.prom_instance_counts}"
  availability_domain = "${lookup(local.availability_domain, "name")}"
  compartment_id      = "${var.instance_compartment_id}"
  display_name        = "${format("%s-%s-%s-00%s", var.instance_tag_region, var.instance_tag_envid, var.instance_tag_app, var.instance_requested_ad)}"
  shape               = "${var.prom_instance_shape}"
  subnet_id           = "${local.subnet_id}"

  source_details {
    source_id   = "${var.prom_instance_source_id}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.instance_ssh_key}"
  }

  freeform_tags {
    ad          = "${lookup(local.availability_domain, "name")}"
    app         = "${var.instance_tag_app}"
    envid       = "${var.instance_tag_envid}"
    envtype     = "${var.instance_tag_envtype}"
    region      = "${var.instance_tag_region}"
    role        = "${var.instance_tag_role}"
    service     = "${var.instance_tag_service}"
    team        = "${var.instance_tag_team}"
    tenancy     = "${var.instance_tag_tenancy_name}"
  }
}

resource "oci_core_volume" "prometheus_volume" {
  count               = "${var.prom_instance_attach_volumes ? local.prom_instance_counts : 0}"
  availability_domain = "${lookup(local.availability_domain, "name")}"
  compartment_id      = "${var.instance_compartment_id}"
   size_in_gbs         = "${var.prom_instance_attach_volumes_size}"
}

resource "oci_core_volume_attachment" "prometheus_volume_attachment" {
  count           = "${var.prom_instance_attach_volumes ? local.prom_instance_counts : 0}"
  attachment_type = "iscsi"
  compartment_id  = "${var.instance_compartment_id}"
  instance_id     = "${element(oci_core_instance.prometheus.*.id, count.index)}"
  volume_id       = "${element(oci_core_volume.prometheus_volume.*.id, count.index)}"
}

resource "dyn_record" "prom_dns" {
  count = "${local.prom_instance_counts}"
  zone  = "${var.dyn_zone}"
  name  = "${format("%s-%s-%s-00%s%s", var.instance_tag_region, var.instance_tag_envid, var.instance_tag_app, var.instance_requested_ad, var.dyn_suffix)}"
  value = "${element(oci_core_instance.prometheus.*.private_ip, count.index)}"
  type  = "A"
  ttl   = "60"
}