#!/bin/bash
sudo apt update && sudo apt -y install haproxy

#replace the private ip below for loadbalancer, master-1, master-2
cat <<EOF | tee /tmp/ha-config
frontend kubernetes-frontend
    bind <loadbalancer-private-ip>:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server kmaster1 <master-1-private-ip>:6443 check fall 3 rise 2
    server kmaster2 <master-2-private-ip>:6443 check fall 3 rise 2
EOF
cat /tmp/ha-config >> /etc/haproxy/haproxy.cfg
sudo service haproxy restart
