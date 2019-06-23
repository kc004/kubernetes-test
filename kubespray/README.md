![Kubernetes Logo](https://raw.githubusercontent.com/kubernetes-sigs/kubespray/master/docs/img/kubernetes-logo.png)

Deploy a Production Ready Kubernetes Cluster
============================================
```
Create a server in a region where do you want to run production setup.

Cloud provider: AWS, 
Servers: t2.micro (for Ansible), t2.medium (for Master, ETCD, Workers) - Ubuntu 18.04
Default Region: eu-central-1.

First install Terraform v0.11.8, Ansible and software-properties-common to the server.

wget https://releases.hashicorp.com/terraform/0.11.8/
unzip terraform_0.11.8_linux_amd64.zip
cp terraform /usr/local/bin/

sudo apt-get install python -y
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
sudo apt-get install python-pip -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible -y

git clone https://github.com/kc004/kubernetes-test.git
sudo pip install -r requirements.txt


Go to the kubespray/contrib/terraform/aws/
Edit creds.tfvars.
If you want to change region then you need to change in var.tf -> cluster_ami -> AMI ID.


Terraform init

Terraform plan -var-file=cred.tfvar

Terraform apply -var-file=cred.tfvar


Terraform will trigger Ansible script for Kubernetes installation. 
It will wait for 150 seconds before execution of ansible script.

  * If you want to change in Ansible values for Kubernetes Cluster then stop it here.
  * Values folder: kubespray/inventory/mycluster/group_vars/  --- k8s-cluster/addons.yml, k8s-cluster/k8s-cluster.yml, all/all.yml
  * ansible-playbook -i kubespray/inventory/mycluster/inventory.ini cluster.yml -e ansible_user=ubuntu -b --become-user=root --flush-cache -c paramiko

At that time, 
You need to copy ELB DNS name and IP address of ELB to paste it in the 
kubespray/inventory/mycluster/group_vars/all/all.yml

ELB DNS name you will find it in the AWS console or in the kubespray/inventory/mycluster/inventory.ini


Wait for around 30 min to ready your infrastructure.
```


 
