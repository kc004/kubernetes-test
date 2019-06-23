/* Security group for Kubernetes EC2 instances */
resource "aws_security_group" "kubernetes-sg" {
  name = "kubernetes-${var.aws_cluster_name}-securitygroup"

  tags = "${merge(var.default_tags, map(
      "Name", "kubernetes-${var.aws_cluster_name}-securitygroup"
    ))}"

  description = "Open all required ports for Kafka instances to communicate with other instances."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

