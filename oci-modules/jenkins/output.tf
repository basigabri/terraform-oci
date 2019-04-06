output "jenkins_private_ip" {
  value = "${oci_core_instance.jenkins.*.private_ip}"
}