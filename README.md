# SampleApp
Multi-tier services setup using [EchoRelay](https://github.com/zerokdotai/EchoRelayApp) application. 

The setup steps are defined in [setup.sh](https://github.com/zerokdotai/SampleApp/blob/main/setup.sh) and uses [kustomize/deploy.sh](https://github.com/zerokdotai/SampleApp/blob/main/kustomize/deploy.sh) to setup services. It also sets up a load generator service in external namespace. 

### Deployment script
`kustomization/deploy.sh`
```
deploy.sh
  -n <service-name> 
  -r <replica-count>
  -t <comma-seperated list of targets>
  -k <minimum latency to introduce in this service>
  -l <maximum latency to introduce in this service>
```

### Setup
setup.sh deploys 4 services. 
- `service1` acts as an ingress service with 2 dependencies (`service2` & `service3`)
- `service3` has dependency on `service4`
```
deploy.sh -n service4 -r 1
deploy.sh -n service3 -r 1 -t service4.default.svc.cluster.local
deploy.sh -n service2 -r 1 -k 0 -l 10
deploy.sh -n service1 -r 1 -t service2.default.svc.cluster.local,service3.default.svc.cluster.local
```
### Result
<img width="910" alt="image" src="https://user-images.githubusercontent.com/5413029/196366721-10b6c687-1aaf-4e40-8b7c-a7d1f0a914df.png">

