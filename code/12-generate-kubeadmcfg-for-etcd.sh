#!/bin/bash

source ./10-export-etcd-hosts.sh

# Create temp directories to store files that will end up on other hosts.
mkdir -p /tmp/${HOST0}/ /tmp/${HOST1}/ /tmp/${HOST2}/

ETCDHOSTS=(${HOST0} ${HOST1} ${HOST2})
NAMES=("infra0" "infra1" "infra2")

for i in "${!ETCDHOSTS[@]}"; do
HOST=${ETCDHOSTS[$i]}
NAME=${NAMES[$i]}
cat << EOF > /tmp/${HOST}/kubeadmcfg.yaml
apiVersion: "kubeadm.k8s.io/v1beta2"
kind: ClusterConfiguration
kubernetesVersion: v1.16.2
etcd:
    local:
        serverCertSANs:
        - "10.152.99.209"
        - "10.142.99.209"
        - "10.152.97.172"
        - "10.142.97.172"
        - "10.152.97.136"
        - "10.142.97.136"
        - "127.0.0.1"
        peerCertSANs:
        - "10.152.99.209"
        - "10.142.99.209"
        - "10.152.97.172"
        - "10.142.97.172"
        - "10.152.97.136"
        - "10.142.97.136"
        - "127.0.0.1"
        extraArgs:
            initial-cluster: ${NAMES[0]}=https://${ETCDHOSTS[0]}:2380,${NAMES[1]}=https://${ETCDHOSTS[1]}:2380,${NAMES[2]}=https://${ETCDHOSTS[2]}:2380
            initial-cluster-state: new
            name: ${NAME}
            listen-peer-urls: https://${HOST}:2380
            listen-client-urls: "https://127.0.0.1:2379,https://${HOST}:2379"
            advertise-client-urls: https://${HOST}:2379
            initial-advertise-peer-urls: https://${HOST}:2380
imageRepository: registry.aliyuncs.com/google_containers # 修改镜像仓库地址，默认为k8s.gcr.io 容易拉取失败
EOF
done
