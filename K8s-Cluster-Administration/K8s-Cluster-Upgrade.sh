#Check the Kubeadm version
kubeadm version
#kubeadm version: &version.Info {Major:"1", Minor:"29", GitVersion:"v1.29.0"}

#unhold the package kubeadm
sudo apt-mark unhold kubeadm
sudo apt-get update && sudo apt install -y kubeadm=1.29.8-1.1 && sudo apt-mark hold kubeadm

#drain the nodes
kubectl drain node --ignore-daemonsets

#unhold the package kubelet & kubectl on the worker nodes
sudo apt install -y kubelet=1.29.8-1.1 kubectl=1.29.8-1.1 && sudo apt-mark hold kubeadm

#restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

#uncordon the node
kubectl uncordon node
