#AWS Access Key
AWS_ACCESS_KEY_ID = ""
#AWS Secret Key
AWS_SECRET_ACCESS_KEY = ""
#EC2 SSH Key Name
AWS_SSH_KEY_NAME = "keyur-eu1"
#AWS Region
AWS_DEFAULT_REGION = "eu-central-1"

#Global Vars
aws_cluster_name = "dev"


#VPC Vars
aws_vpc_id = "vpc-36de585d"
aws_subnet_ids_private = ["subnet-99e55ce4", "subnet-a370eeee", "subnet-d9b2f3b2"]
aws_subnet_ids_public = ["subnet-99e55ce4", "subnet-a370eeee", "subnet-d9b2f3b2"]
aws_vpc_cidr_block = "10.250.192.0/18"
aws_cidr_subnets_private = ["10.250.192.0/20","10.250.208.0/20"]
aws_cidr_subnets_public = ["10.250.224.0/20","10.250.240.0/20"]
aws_avail_zones = ["eu-central-1a,eu-central-1b,eu-cetral-1c"]

#Bastion Host
aws_bastian_ami = "ami-5900cc36"
aws_bastion_size = "t2.medium"


#Kubernetes Cluster

aws_kube_master_num = 3
aws_kube_master_size = "t2.medium"

aws_etcd_num = 3
aws_etcd_size = "t2.medium"

aws_kube_worker_num = 3
aws_kube_worker_size = "t2.medium"

aws_cluster_ami = "ami-903df7ff"

#Settings AWS ELB

aws_elb_api_port = 6443
k8s_secure_api_port = 6443
kube_insecure_apiserver_address = "0.0.0.0"

default_tags = {
  Env = "dev"
#  Product = "kubernetes"
}

inventory_file = "../../../inventory/hosts"
