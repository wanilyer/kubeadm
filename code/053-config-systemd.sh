#!/bin/bash

# docker 配置文件
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://xxx.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

# 配置kubelet启动参数: KUBELET_EXTRA_ARGS
cat << EOF > /etc/sysconfig/kubelet 
KUBELET_EXTRA_ARGS=--pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 --cgroup-driver=systemd
EOF

systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet

