#!/bin/sh
kubeadm reset
docker rm -f $(docker ps -qa)
docker volume rm $(docker volume ls -q)
docker rmi $(docker images -q)
cleanupdirs="/var/lib/etcd /etc/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico /opt/rke"
for dir in $cleanupdirs; do
  echo "Removing $dir"
  rm -rf $dir
done
rm -rf /var/lib/rook && rm -rf /etc/ceph && rm -rf /var/lib/rancher && rm -rf /var/lib/calico && rm -rf /etc/kubernetes && rm -rf /var/lib/kubelet
