output "public_subnet_ids" { 
  value = "${oci_core_subnet.public.*.id}"
}

output "data_subnet_ids" { 
  value = "${oci_core_subnet.data.*.id}"
}

output "app_subnet_ids" { 
  value = "${oci_core_subnet.app.*.id}"
}

output "vcn_id" {
  value = "${module.network.vcn_id}"
}

output "oke_id" { 
  value = "${oci_containerengine_cluster.oke.id}"
}
