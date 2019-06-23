resource "aws_elb" "aws-elb-api" {
  name            = "kubernetes-elb-${var.aws_cluster_name}"
  subnets         = ["var.aws_subnet_ids_public"]
  security_groups = ["${aws_security_group.aws-elb.id}"]

  listener {
    instance_port     = "${var.k8s_secure_api_port}"
    instance_protocol = "tcp"
    lb_port           = "${var.aws_elb_api_port}"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:${var.k8s_secure_api_port}"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${merge(var.default_tags, map(
    "Name", "kubernetes-${var.aws_cluster_name}-elb-api"
  ))}"
}

