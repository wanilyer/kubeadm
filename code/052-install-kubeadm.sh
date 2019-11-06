#!/bin/bash

yum install -y kubeadm-1.16.2-0

sudo systemctl enable kubelet 
sudo systemctl start kubelet
