distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | sudo tee /etc/yum.repos.d/nvidia-docker.repo

yum install -y nvidia-docker2

pkill -SIGHUP dockerd

cat > /etc/docker/daemon.json <<EOF
{
  "default-runtime": "nvidia",
  "runtimes": {
     "nvidia": {
        "path": "/usr/bin/nvidia-container-runtime",
        "runtimeArgs": []
     }
  },
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

systemctl restart docker
