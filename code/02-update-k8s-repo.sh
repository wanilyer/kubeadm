#!/bin/bash

## 配置默认源
## 备份
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

## 下载阿里源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

## 刷新
yum makecache fast

## 配置k8s源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
EOF

## 重建yum缓存
yum clean all
yum makecache fast
yum -y update

## 下载docker的yum源文件
wget http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum -y install yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo docker-ce.repo
