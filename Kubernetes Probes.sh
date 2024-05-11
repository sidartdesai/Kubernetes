Kubernetes Probes:

1. LivenessProbe: depends on startup probe
  - responsible to telling K8s cluster that the docker container needs a restart.
  ex code:
  =================================
  livenessProbe:
    httpGet:
      path: /hello              --> Health endpoint of application
      port: 8080                --> application port
    inititalDelaySeconds: 15    --> First time when the liveness will be tested
    periodSeconds: 10           --> Regular interval after application startup
  ==================================
2. ReadinessProbe:
  - doorkeeper for incoming traffic if POD is healthy & if not then it will remove from the load balancer.
  ex code: 
  =================================
  readinessProbe:
    httpGet:
      path: /hello              --> Health endpoint of application
      port: 8080                --> application port
    inititalDelaySeconds: 15    --> First time when the readiness will be tested
    periodSeconds: 10           --> Regular interval
  ==================================
3. StartupProbe:
  - to check if the application inside the docker container has started, if not then keep liveness and readiness probes disabled.
  ex code: 
  =================================
  startupProbe:
    httpGet:
      path: /hello              --> Health endpoint of application
      port: 8080                --> application port
    failureThreshold: 30        --> First time when the failureThreshold will be tested (startup will wait for 30 minutes = 30*10)
    periodSeconds: 10           --> Regular interval
  ==================================
  
