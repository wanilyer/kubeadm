#!/bin/bash

source ./ADD-10-export-etcd-hosts.sh

# 备份本机的certs
cp -R /etc/kubernetes/pki /etc/kubernetes/pki-bak
find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

for HOST in ${HOSTS[@]}
  do
    echo ">>> ${HOST} init certs!"
    kubeadm init phase certs etcd-server --config=/tmp/${HOST}/kubeadmcfg.yaml
    kubeadm init phase certs etcd-peer --config=/tmp/${HOST}/kubeadmcfg.yaml
    kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST}/kubeadmcfg.yaml
    kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST}/kubeadmcfg.yaml
    cp -R /etc/kubernetes/pki /tmp/${HOST}/
    # cleanup non-reusable certificates
    find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete
  done

mv /etc/kubernetes/pki-bak /etc/kubernetes/pki

