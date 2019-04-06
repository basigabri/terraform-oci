resource "oci_core_instance" "jenkins" {
  count               = "${var.instance_count}"
  availability_domain = "${lookup(var.availability_domains[count.index % 3], "name")}"
  compartment_id      = "${var.instance_compartment_id}"
  display_name        = "${format("%s-%s-%s-%03d", var.instance_name, var.instance_tag_envid, var.instance_tag_region, count.index)}"
  shape               = "${var.instance_shape}"
  subnet_id           = "${element(var.subnet_ids, count.index % length(var.subnet_ids))}"

  source_details {
    source_id   = "${var.instance_source_id}"
    source_type = "image"
  }

  metadata {
    ssh_authorized_keys = "${var.instance_authorized_key}"
  }
  
  freeform_tags {
    ad          = "${lookup(var.availability_domains[count.index % 3], "name")}"
    app         = "${var.instance_tag_app}"
    envid       = "${var.instance_tag_envid}"
    envtype     = "${var.instance_tag_envtype}"
    region      = "${var.instance_tag_region}"
    service     = "${var.instance_tag_service}"
    team        = "${var.instance_tag_team}"
  }
  lifecycle {
    ignore_changes = ["metadata"]
  }

 }

resource "oci_core_volume" "jenkins" {
  count               = "${var.instance_volume_size > 0 ? var.instance_count : 0}"
  availability_domain = "${lookup(var.availability_domains[count.index % 3], "name")}"
  compartment_id      = "${var.instance_compartment_id}"
  size_in_gbs         = "${var.instance_volume_size}"
}

resource "oci_core_volume_attachment" "jenkins" {
  count           = "${var.instance_volume_size > 0 ? var.instance_count : 0}"
  attachment_type = "iscsi"
  compartment_id  = "${var.instance_compartment_id}"
  instance_id     = "${element(oci_core_instance.jenkins.*.id, count.index)}"
  volume_id       = "${element(oci_core_volume.jenkins.*.id, count.index)}"

  lifecycle {
    ignore_changes = ["oci_core_volume_attachment"]
  }
}

resource "dyn_record" "jenkins_dns" {
  count = "${var.instance_count}"
  zone  = "${var.dyn_zone}"
  name  = "${format("%s-%s-%s-%03d", var.instance_name, var.instance_tag_envid, var.instance_tag_region, count.index)}"
  value = "${element(oci_core_instance.jenkins.*.private_ip, count.index)}"
  type  = "A"
  ttl   = "60"
}