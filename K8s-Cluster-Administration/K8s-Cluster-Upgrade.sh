#Check the Kubeadm version
kubeadm version
#kubeadm version: &version.Info {Major:"1", Minor:"29", GitVersion:"v1.29.0"}

#updagre the control plane
#determine the version to be upgraded to
sudo apt update && apt-cache madison kubeadm | tac
   kubeadm | 1.29.0-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
   kubeadm | 1.29.1-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
   kubeadm | 1.29.2-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
   kubeadm | 1.29.3-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
   kubeadm | 1.29.4-2.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
   kubeadm | 1.29.5-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
   kubeadm | 1.29.6-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
   kubeadm | 1.29.7-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
   kubeadm | 1.29.8-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages

#Upgrade kubeadm
apt-mark unhold kubeadm && sudo apt-get update && apt-get install -y kubeadm='1.29.8-1.1' apt-mark hold kubeadm

#Verify that the download works and has the expected version:
kubeadm version

#Verify the upgrade plan:
kubeadm upgrade plan

#Apply the upgrade
sudo kubeadm upgrade apply v1.29.8

#drain the nodes
kubectl drain node --ignore-daemonsets

#unhold & upgrade the package kubelet & kubectl on the worker nodes
sudo apt install -y kubelet=1.29.8-1.1 kubectl=1.29.8-1.1 && sudo apt-mark hold kubeadm

#restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

#uncordon the node
kubectl uncordon node

#verify the upgrade
kubectl get nodes
