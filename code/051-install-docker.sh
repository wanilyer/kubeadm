#!/bin/bash

yum install -y docker-ce-18.09.9-3.el7
systemctl enable docker
systemctl start docker

cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://xxx.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=cgroupfs"],
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

systemctl restart docker
