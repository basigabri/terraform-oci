data "oci_containerengine_cluster_option" "oke" {
  cluster_option_id = "all"
}

resource "oci_containerengine_cluster" "oke" {
  depends_on         = ["oci_core_subnet.public"]
  compartment_id     = "${var.compartment_id}"
  kubernetes_version = "${element(data.oci_containerengine_cluster_option.oke.kubernetes_versions, 2)}"
  name               = "${var.oke_cluster_name}"
  vcn_id             = "${module.network.vcn_id}"

  options {
    service_lb_subnet_ids = ["${slice(oci_core_subnet.public.*.id, 0, 2)}"]

    add_ons {
      is_kubernetes_dashboard_enabled = "${var.oke_dashboard_enabled}"
      is_tiller_enabled               = "${var.oke_tiller_enabled}"
    }

    kubernetes_network_config {
      pods_cidr     = "${var.oke_pods_cidr}"
      services_cidr = "${var.oke_services_cidr}"
    }

  }
}
