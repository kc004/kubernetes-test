/* Variables */
provider "aws" {
  region     = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

variable "aws_access_key" {
  description = "Enter AWS access key"
}

variable "aws_secret_key" {
  description = "Enter AWS secret key"
}

variable "region" {
  description = "Select the default AWS region for the deployment."
}

variable "cluster_ami" {
  type = "map"
  default = {
    ap-southeast-1 = "ami-aacc7dc9"
    eu-central-1 = "ami-090f10efc254eaf55" /* Ubuntu AMI */
  }
  description = "Select appropriate AMI for required Linux Distro. Default is Ubuntu."
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs in Stg."
  type        = "list"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs in Stg."
  type        = "list"
}

variable "availability_zones" {
  description = "List of availability zones."
  type        = "list"
}

variable "key_name" {
  description = "Key pair to be used for launching instances."
}

variable "instance_types" {
  description = "Instance type to be used for instances"
  type = "list"
  #default = "t2.medium"
}

variable "aws_cluster_name" {
  description = "Name of the Kubernetes cluster you want to set in AWS"
}

/*
* AWS ELB Settings
*
*/
variable "aws_elb_api_port" {
  description = "Port for AWS ELB"
}

variable "k8s_secure_api_port" {
  description = "Secure Port of K8S API Server"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = "map"
}

variable "inventory_file" {
  description = "Where to store the generated inventory file"
}
