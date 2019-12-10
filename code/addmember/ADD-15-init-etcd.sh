#!/bin/bash

source ./ADD-10-export-etcd-hosts.sh

for HOST in ${HOSTS[@]}
  do
    echo ">>> ${HOST} init etcd!"
    ssh root@${HOST} "kubeadm init phase etcd local --config=/root/kubeadmcfg.yaml"    
  done
