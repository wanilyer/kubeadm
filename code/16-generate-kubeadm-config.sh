#!/bin/bash

source ./10-export-etcd-hosts.sh

export endpoint="10.142.86.143:8443"

cat <<EOF > externam-etcd-kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
controlPlaneEndpoint: "${endpoint}"
kubernetesVersion: v1.16.2
networking:
    podSubnet: "172.30.0.0/16" # 与网络方案的CIDR相对应
imageRepository: registry.aliyuncs.com/google_containers # 修改镜像仓库地址，默认为k8s.gcr.io 会拉取失败
etcd:
    external:
        endpoints:
        - https://${HOST0}:2379
        - https://${HOST1}:2379
        - https://${HOST2}:2379
        caFile: /etc/kubernetes/pki/etcd/ca.crt
        certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
        keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key
EOF
