#!/bin/bash

source ./10-export-etcd-hosts.sh

export HOSTS=(${HOST1} ${HOST2})

for HOST in ${HOSTS[@]}
  do
    echo ">>> ${HOST}"
    scp -r /tmp/${HOST}/* root@${HOST}:
    ssh root@${HOST} \
      "mkdir -p /etc/kubernetes/;rm -rf /etc/kubernetes/pki/; mv -f pki /etc/kubernetes/;exit"
  done
