What is Service Mesh ?
- Traffic Management
- Traffic management between services & resources inside the cluster

Features
- MTLS (mutual TLS)
  service communicate internally using secure TLS
- Kiali -> service to service communication
  observability

How istio works ?
Istio adds a sidecar container
envoy proxy container
istio uses admission controllers to inject the sidecar containers into the the pods

admission controller
- can mutate(modify) or validate any request
- there are 30+ admission conotrollers by default and embedded inside the apiserver
- 
