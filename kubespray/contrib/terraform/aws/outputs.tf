output "k8s_master_ids" {
  value = "${aws_instance.k8s-master.*.id}"
}
output "k8s_master_ips" {
  value = "${aws_instance.k8s-master.*.private_ip}"
}

output "k8s_etcd_ids" {
  value = "${aws_instance.k8s-etcd.*.id}"
}

output "k8s_etcd_ips" {
  value = "${aws_instance.k8s-etcd.*.private_ip}"
}

output "k8s_worker_ids" {
  value = "${aws_instance.k8s-worker.*.id}"
}
output "k8s_worker_ips" {
  value = "${aws_instance.k8s-worker.*.private_ip}"
}

output "k8s_elb_dns" {
  value = "${aws_elb.aws-elb-api.dns_name}"
}

output "kube_master_role_arn" {
  value = "${aws_iam_role.kube-master.arn}"
}

output "kube_worker_role_arn" {
  value = "${aws_iam_role.kube-worker.arn}"
}

output "kube_master_profile" {
  value = "${aws_iam_instance_profile.kube-master.name}"
}

output "kube_worker_profile" {
  value = "${aws_iam_instance_profile.kube-worker.name}"
}

