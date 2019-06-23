/* Security group for Confluent Kafka EC2 instances */
resource "aws_security_group" "elb-sg" {
  name = "kubernetes-${var.aws_cluster_name}-securitygroup-elb"

  tags = "${merge(var.default_tags, map(
      "Name", "kubernetes-${var.aws_cluster_name}-securitygroup-elb"
    ))}"

  description = "Open all required ports for Kafka instances to communicate with other instances."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.aws_elb_api_port}"
    to_port     = "${var.k8s_secure_api_port}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a new AWS ELB for K8S API
resource "aws_elb" "aws-elb-api" {
  name            = "kubernetes-elb-${var.aws_cluster_name}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.elb-sg.id}"]
  instances       = ["${aws_instance.k8s-master.*.id}"]

  listener {
    instance_port     = "${var.k8s_secure_api_port}"
    instance_protocol = "TCP"
    lb_port           = "${var.aws_elb_api_port}"
    lb_protocol       = "TCP"
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

