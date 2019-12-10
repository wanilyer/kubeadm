#!/bin/bash

source ./ADD-10-export-etcd-hosts.sh

# 配置kubelet启动参数: KUBELET_EXTRA_ARGS
# 参考: https://kubernetes.io/docs/setup/independent/kubelet-integration/#the-kubelet-drop-in-file-for-systemd
cat << EOF > kubelet 
KUBELET_EXTRA_ARGS=--pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
EOF

# 配置 kubelet cgroup driver
# EOF上的单引号表示输出到文件时，不替换其中的变量，因为KUBELET_EXTRA_ARGS变量在kubelet启动时会自己替换
cat << 'EOF' > 20-etcd-service-manager.conf
[Service]
ExecStart=
#  Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd $KUBELET_EXTRA_ARGS
Restart=always
EOF

# 远程机器上执行脚本
cat << EOF > config-systemd.sh
#!/bin/bash
mkdir -p /etc/systemd/system/kubelet.service.d/
mv 20-etcd-service-manager.conf /etc/systemd/system/kubelet.service.d/

mv kubelet /etc/sysconfig/

systemctl daemon-reload
systemctl restart kubelet
EOF

for HOST in ${HOSTS[@]}
  do
    echo ">>> ${HOST} config kubelet!"
    scp -r kubelet root@${HOST}:
    scp -r 20-etcd-service-manager.conf root@${HOST}:
    scp -r config-systemd.sh root@${HOST}:
    ssh root@${HOST} \
      "chmod +x config-systemd.sh; sh ./config-systemd.sh; exit"
  done

