#!/bin/bash

# 安装依赖包
# ipvs依赖ipset，ntp保证各机器系统时间同步
sudo yum install -y epel-release
sudo yum install -y conntrack ntpdate ntp ipvsadm ipset jq iptables curl sysstat libseccomp wget

# 关闭防火墙,清理防火墙规则并设置默认转发策略
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat
sudo iptables -P FORWARD ACCEPT

# 关闭swap分区，如果开启了 swap 分区，kubelet 会启动失败
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 

# 关闭SELinux
sudo setenforce 0
sed -i 's/SELINUX=permissive/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# 关闭dnsmasq
# sudo systemctl stop dnsmasq
# sudo systemctl disable dnsmasq

# 加载内核模块
modprobe ip_vs_rr
modprobe br_netfilter

# 设置系统时区
timedatectl set-timezone Asia/Shanghai

# 将当前的 UTC 时间写入硬件时钟
timedatectl set-local-rtc 0

# 重启依赖于系统时间的服务
systemctl restart rsyslog 
systemctl restart crond




