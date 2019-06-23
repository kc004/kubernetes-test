
/* Creating an EC2 instance for Kubernetes Master*/
resource "aws_instance" "k8s-master" {
  ami                    = "${lookup(var.cluster_ami, var.region)}"
  instance_type          = "${element(var.instance_types, 1)}"
  subnet_id              = "${element(var.private_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes-sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.kube-master.name}"
  key_name               = "${var.key_name}"
  depends_on           = ["aws_iam_role.kube-master", "aws_iam_instance_profile.kube-master"]
  count                  = 3

  tags = "${merge(var.default_tags, map(
      "Name", "kubernetes-${var.aws_cluster_name}-master${count.index}",
      "kubernetes.io/cluster/${var.aws_cluster_name}", "member",
      "Role", "master"
    ))}"
}

/* Creating an EC2 instance for Kubernetes etcd*/
resource "aws_instance" "k8s-etcd" {
  ami                    = "${lookup(var.cluster_ami, var.region)}"
  instance_type          = "${element(var.instance_types, 1)}"
  subnet_id              = "${element(var.private_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes-sg.id}"]
  key_name               = "${var.key_name}"
  count                  = 3

  tags = "${merge(var.default_tags, map(
      "Name", "kubernetes-${var.aws_cluster_name}-etcd${count.index}",
      "kubernetes.io/cluster/${var.aws_cluster_name}", "member",
      "Role", "etcd"
    ))}"
}

/* Creating an EC2 instance for Kubernetes worker*/
resource "aws_instance" "k8s-worker" {
  ami                    = "${lookup(var.cluster_ami, var.region)}"
  instance_type          = "${element(var.instance_types, 1)}"
  subnet_id              = "${element(var.private_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes-sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.kube-worker.name}"
  key_name               = "${var.key_name}"
  depends_on           = ["aws_iam_role.kube-worker", "aws_iam_instance_profile.kube-worker"]
  count                  = 4

  tags = "${merge(var.default_tags, map(
      "Name", "kubernetes-${var.aws_cluster_name}-worker${count.index}",
      "kubernetes.io/cluster/${var.aws_cluster_name}", "member",
      "Role", "worker"
    ))}"
}

/*
* Create Kubespray Inventory File
*
*/
data "template_file" "inventory" {
  template = "${file("${path.module}/templates/inventory.tpl")}"

  vars {
    connection_strings_master = "${join("\n",formatlist("%s ansible_host=%s",aws_instance.k8s-master.*.tags.Name, aws_instance.k8s-master.*.private_ip))}"
    connection_strings_node   = "${join("\n", formatlist("%s ansible_host=%s", aws_instance.k8s-worker.*.tags.Name, aws_instance.k8s-worker.*.private_ip))}"
    connection_strings_etcd   = "${join("\n",formatlist("%s ansible_host=%s", aws_instance.k8s-etcd.*.tags.Name, aws_instance.k8s-etcd.*.private_ip))}"
    list_master               = "${join("\n",aws_instance.k8s-master.*.tags.Name)}"
    list_node                 = "${join("\n",aws_instance.k8s-worker.*.tags.Name)}"
    list_etcd                 = "${join("\n",aws_instance.k8s-etcd.*.tags.Name)}"
    elb_api_fqdn              = "apiserver_loadbalancer_domain_name=\"${aws_elb.aws-elb-api.dns_name}\""
  }
}

resource "null_resource" "inventories" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ${var.inventory_file}"
  }

  triggers {
    template = "${data.template_file.inventory.rendered}"
  }
}

resource "null_resource" "ansible_invoke" {
  depends_on = ["null_resource.inventories"]
  provisioner "local-exec" {
    command = "sleep 150 && cd /home/terraform-kubespray/kubespray && ansible-playbook -i /home/terraform-kubespray/kubespray/inventory/mycluster/inventory.ini cluster.yml -e ansible_user=ubuntu -b --become-user=root --flush-cache -c paramiko"
  }
}
