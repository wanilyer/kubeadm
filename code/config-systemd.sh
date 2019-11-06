#!/bin/bash
mkdir -p /etc/systemd/system/kubelet.service.d/
mv 20-etcd-service-manager.conf /etc/systemd/system/kubelet.service.d/

mv kubelet /etc/sysconfig/

systemctl daemon-reload
systemctl restart kubelet
