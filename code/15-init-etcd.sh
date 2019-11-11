#!/bin/bash

source ./10-export-etcd-hosts.sh

kubeadm init phase kubelet-start --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase etcd local --config=/tmp/${HOST0}/kubeadmcfg.yaml
ssh root@${HOST1} "kubeadm init phase kubelet-start --config=/root/kubeadmcfg.yaml; kubeadm init phase etcd local --config=/root/kubeadmcfg.yaml"
ssh root@${HOST2} "kubeadm init phase kubelet-start --config=/root/kubeadmcfg.yaml; kubeadm init phase etcd local --config=/root/kubeadmcfg.yaml"
