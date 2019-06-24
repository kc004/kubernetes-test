#!/bin/bash
DATE=$(date +%Y-%m-%d)
for ns in $(kubectl get ns --no-headers | cut -d " " -f1); do
  if { [ "$ns" != "kube-system" ]; }; then
  kubectl --namespace="${ns}" get --export -o=json svc,rc,deplo,cm,secrets,ds,sts,sa,clusterrolebinding,rolebinding,ing,certificate,sc,pvc,hpa,cj,jobs | \
jq '.items[] |
    select(.type!="kubernetes.io/service-account-token") |
    del(
        .spec.clusterIP,
        .metadata.uid,
        .metadata.selfLink,
        .metadata.resourceVersion,
        .metadata.creationTimestamp,
        .metadata.generation,
        .status,
        .spec.template.spec.securityContext,
        .spec.template.spec.dnsPolicy,
        .spec.template.spec.terminationGracePeriodSeconds,
        .spec.template.spec.restartPolicy
    )' >> "/home/backup/my-cluster_$DATE.json"
  fi
done

