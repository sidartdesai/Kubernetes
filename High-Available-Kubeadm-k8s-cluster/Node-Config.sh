#!/bin/bash

# Disable swap
sudo swapoff -a

# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# load kernel modules, particularly for container networking and overlay file systems,used in containerized environments like Docker and Kubernetes.
sudo modprobe overlay && sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

## Install CRIO Runtime
sudo apt-get update -y && sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates gpg
sudo curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list
sudo apt-get update -y && sudo apt-get install -y cri-o && sudo systemctl daemon-reload && sudo systemctl enable crio --now && sudo systemctl start crio.service
echo "CRI runtime installed successfully"

# Add Kubernetes APT repository and install required packages
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y && sudo apt-get install -y kubelet="1.29.0-*" kubectl="1.29.0-*" kubeadm="1.29.0-*"
sudo apt-get update -y && sudo apt-get install -y jq
sudo systemctl enable --now kubelet && sudo systemctl start kubelet

# Join any number of worker nodes by running the following on each as root:
sudo kubeadm join 172.31.45.2:6443 --token tyb6ro.286vubja00b0948j \
        --discovery-token-ca-cert-hash sha256:02ccba04b5f3968c43bd4b8405c75e2cb48ba69eb4f72fe5c161ad59a8efc259
        
# Join commands are displayed when the cluster is initialized to regenerate the join command use the command below on master
sudo kubeadm token create --print-join-command

