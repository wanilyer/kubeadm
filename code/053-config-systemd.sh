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
KUBELET_EXTRA_ARGS=--pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
EOF

# 配置 kubelet cgroup driver
# EOF上的单引号表示输出到文件时，不替换其中的变量
# kubelet启动时会去/etc/sysconfig/kubelet文件中查找KUBELET_EXTRA_ARGS变量的值
cat << 'EOF' > /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
#  Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd $KUBELET_EXTRA_ARGS
Restart=always
EOF

systemctl restart docker
systemctl daemon-reload
systemctl restart kubelet

