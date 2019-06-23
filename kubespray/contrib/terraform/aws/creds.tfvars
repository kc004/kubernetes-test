aws_access_key      = "XXXXXXXXXXXXXXXXXXXXXXXXXXX" # AWS ACCESS KEY
aws_secret_key      = "XXXXXXXXXXXXXXXXXXXXXXXXXXX" # AWS SECRET KEY
region              = "eu-central-1"
vpc_id              = "vpc-36de585d" # VPC ID of the vpc present in the above region
public_subnet_ids   = ["subnet-d9b2f3b2","subnet-99e55ce4", "subnet-a370eeee"] # List of Public Subnets present in the above VPC in conjunction with Availability Zones
private_subnet_ids  = ["subnet-d9b2f3b2","subnet-99e55ce4", "subnet-a370eeee"] # List of Private Subnets present in the above VPC in conjunction with Availability Zones
availability_zones  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
key_name            = "XXXXXXXXXXXXXXXXXXXXXXXXXXX" # Key file name in that region
instance_types	    = ["t2.small", "t2.medium"]
aws_cluster_name    = "devtest"
aws_elb_api_port    = 6443
k8s_secure_api_port = 6443
kube_insecure_apiserver_address = "0.0.0.0"
default_tags = {
  Env = "devtest"
  Product = "kubernetes"
}
inventory_file = "../../../inventory/mycluster/inventory.ini"

