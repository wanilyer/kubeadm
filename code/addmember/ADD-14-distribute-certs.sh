#!/bin/bash

source ./ADD-10-export-etcd-hosts.sh

for HOST in ${HOSTS[@]}
  do
    echo ">>> ${HOST} copy certs!"
    scp -r /tmp/${HOST}/* root@${HOST}:
    ssh root@${HOST} \
      "mkdir -p /etc/kubernetes/;rm -rf /etc/kubernetes/pki/; mv -f pki /etc/kubernetes/;exit"
  done
