resource "aws_instance" "node" {
  ami                                  = var.ubuntu-ami
  associate_public_ip_address          = true
  iam_instance_profile                 = aws_iam_instance_profile.example_instance_profile.name
  instance_type                        = var.ha_instance_type
  #key_name                             = "RedivusServers"
  subnet_id                            = var.subnet-id
  tags = {
    Name = "${var.project}-node"
  }
  tags_all = {
    Name = "${var.project}-node"
  }
  tenancy                = "default"
  user_data = <<-EOF
              #!/bin/bash
              sudo hostnamectl set-hostname ${var.project}-node-1
              sudo systemctl stop snap.amazon-ssm-agent.amazon-ssm-agent.service
              sudo systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent.service

              # Disable swap
              sudo swapoff -a

              # Create the .conf file to load the modules at bootup
              echo "overlay" > /etc/modules-load.d/k8s.conf
              echo "br_netfilter" >> /etc/modules-load.d/k8s.conf
                            
              # load kernel modules, particularly for container networking and overlay file systems,used in containerized environments like Docker and Kubernetes.
              sudo modprobe overlay && sudo modprobe br_netfilter

              # sysctl params required by setup, params persist across reboots
              echo "net.bridge.bridge-nf-call-iptables  = 1" > /etc/sysctl.d/k8s.conf
              echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/k8s.conf
              echo "net.ipv4.ip_forward                 = 1" >> /etc/sysctl.d/k8s.conf
              
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

              # Pull the Images required for bootstrapping
              sudo kubeadm config images pull
              EOF
  vpc_security_group_ids = [aws_security_group.node.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "master" {
  ami                                  = var.ubuntu-ami
  associate_public_ip_address          = true
  iam_instance_profile                 = aws_iam_instance_profile.example_instance_profile.name
  instance_type                        = var.master_instance_type
  #key_name                             = "RedivusServers"
  subnet_id                            = var.subnet-id
  tags = {
    Name = "${var.project}-master"
  }
  tags_all = {
    Name = "${var.project}-master"
  }
  tenancy                = "default"
  user_data = <<-EOF
              #!/bin/bash
              sudo hostnamectl set-hostname ${var.project}-master
              sudo systemctl stop snap.amazon-ssm-agent.amazon-ssm-agent.service
              sudo systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent.service

              # Disable swap
              sudo swapoff -a

              # Create the .conf file to load the modules at bootup
              echo "overlay" > /etc/modules-load.d/k8s.conf
              echo "br_netfilter" >> /etc/modules-load.d/k8s.conf
                            
              # load kernel modules, particularly for container networking and overlay file systems,used in containerized environments like Docker and Kubernetes.
              sudo modprobe overlay && sudo modprobe br_netfilter

              # sysctl params required by setup, params persist across reboots
              echo "net.bridge.bridge-nf-call-iptables  = 1" > /etc/sysctl.d/k8s.conf
              echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/k8s.conf
              echo "net.ipv4.ip_forward                 = 1" >> /etc/sysctl.d/k8s.conf
              
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

              # Pull the Images required for bootstrapping
              sudo kubeadm config images pull

              # Initialize the Cluster
              # Initialize the loadbalancer(haproxy) before initializing the cluster
              sudo kubeadm init 

              # Configure the kubeconfig file to be used by default
              mkdir -p /home/ubuntu/.kube && sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config && sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config

              # Install network plugin = weave net
              kubectl apply -f https://reweave.azurewebsites.net/k8s/v1.29/net.yaml
              EOF
  vpc_security_group_ids = [aws_security_group.master.id]

  lifecycle {
    create_before_destroy = true
  }
}
