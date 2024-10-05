curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm repo list
kubeadm token create --print-join-command
kubectl get nodes
helm search repo mysql

helm install my-mysql stable/mysql
ubuntu@k8s-kubeadm-master:~$ helm install my-mysql stable/mysql
WARNING: This chart is deprecated
NAME: my-mysql
LAST DEPLOYED: Mon Sep 30 09:58:05 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
MySQL can be accessed via port 3306 on the following DNS name from within your cluster:
my-mysql.default.svc.cluster.local

To get your root password run:

    MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default my-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo)

To connect to your database:

1. Run an Ubuntu pod that you can use as a client:

    kubectl run -i --tty ubuntu --image=ubuntu:16.04 --restart=Never -- bash -il

2. Install the mysql client:

    $ apt-get update && apt-get install mysql-client -y

3. Connect using the mysql cli, then provide your password:
    $ mysql -h my-mysql -p

To connect to your database directly from outside the K8s cluster:
    MYSQL_HOST=127.0.0.1
    MYSQL_PORT=3306

    # Execute the following command to route the connection:
    kubectl port-forward svc/my-mysql 3306

    mysql -h ${MYSQL_HOST} -P${MYSQL_PORT} -u root -p${MYSQL_ROOT_PASSWORD}
helm lint .
helm template . > test.yml -- check if the values are correctly applied and no placeholder is there
helm ls
helm history app
helm rollback app version
