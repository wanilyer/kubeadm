#!/bin/bash

source ./ADD-10-export-etcd-hosts.sh

INIT_CLUSTER=${INITIAL_CLUSTER}

for i in "${!HOSTS[@]}"; do
HOST=${HOSTS[$i]}
NAME=${NAMES[$i]}

INIT_CLUSTER=${INIT_CLUSTER},${NAME}=https://${HOST}:2380

# Create temp directories to store files that will end up on other hosts.
mkdir -p /tmp/${HOST}/

cat << EOF > /tmp/${HOST}/kubeadmcfg.yaml
apiVersion: "kubeadm.k8s.io/v1beta2"
kind: ClusterConfiguration
kubernetesVersion: v1.16.2
etcd:
    local:
        serverCertSANs:
        - "${HOST}"
        peerCertSANs:
        - "${HOST}"
        extraArgs:
            initial-cluster: ${INIT_CLUSTER}
            initial-cluster-state: existing
            name: ${NAME}
            listen-peer-urls: https://${HOST}:2380
            listen-client-urls: "https://127.0.0.1:2379,https://${HOST}:2379"
            advertise-client-urls: https://${HOST}:2379
            initial-advertise-peer-urls: https://${HOST}:2380
imageRepository: registry.aliyuncs.com/google_containers # 修改镜像仓库地址，默认为k8s.gcr.io 容易拉取失败
EOF
done
