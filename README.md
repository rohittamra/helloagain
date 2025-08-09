# DevOps Coding Challenge

## 1. Cloud Provider Setup:

I have used Azure for this challenge 

Created the azure account by signing in in microsoft azure portal. Then added a subscription and linked a payment account with it.

---

## 2. Kubernetes Cluster:

Once that it is done rest I have done through github.I have provided the challenge repo as a public access 

[https://github.com/rohittamra/helloagain/tree/main](https://github.com/rohittamra/helloagain/tree/main) 

[Pipeline that works](https://github.com/rohittamra/helloagain/actions/runs/16847118985/job/47728214060)

There are four folders which are used to finish the process (explanation is as below):

- `.github/workflows` -> contains the ci-cd pipeline which will trigger pipeline(in this case - actions)  
- `cors_application` -> a cors api running in server.js.  
- `kuberenetes` -> the configuration of manifests files which will run in aks cluster  
- `terraform` -> the IAC which will create the resource group, subnet, AKS cluster etc  
<img width="1856" height="610" alt="image" src="https://github.com/user-attachments/assets/232b8257-c0c2-434b-a2d6-f577411844ce" />


In `github/workflows` -> `ci.yml` which will trigger actions(ci-cd pipeline) has three stages:

### Stage 1: terraform
- `az login`, terraform initialisation, planning to give an overview, apply to implement (more explainantion in terraform folder description) and output to see what are valued throwed is configured in this

### Stage 2: docker_build
- here the `cors_application` folder is built by running docker build and docker push and sent to docker hub  
[https://hub.docker.com/repository/docker/rohit17061997/cors-proxy/general](https://hub.docker.com/repository/docker/rohit17061997/cors-proxy/general)  

### Stage 3: k8s_deploy
- Here the Kubernetes folder have manifests and are deployed in this stage. Also testing of the curl command to check if ours cors-proxy is running properly or not.

---

## 3. IAC

Used terraform for this case.The files used are as below:

- `variables.tf` -> all the general global variables which are used everywhere in all modules are to be given here.  
- `nodepools.tf` -> how many number of user pools are to be used and what os type etc configuration for AKS node pools are given here.  
- `main.tf` -> the main resource definitions (AKS cluster, networking, etc.)  
- `outputs.tf` -> this will have the variables which are been shown in the output after the values are stored (values you want to show after terraform apply)  
- `provider.tf` -> is to let terraform know what type of cloud we are gonna use and credentials to use.  

---

## 4. Application

I used a cors demo from internet (`server.js`)  

The service is handling HTTP requests, add the appropriate CORS headers, and forward the requests to the target server.  

The CORS proxy listens for incoming HTTP requests and attaches the required `Access-Control-Allow-*` headers to enable cross-origin requests from browsers. It then forwards these requests to the intended target server and relays the responses back to the client. This allows client-side applications to bypass browser CORS restrictions without changing the target server.  

I used a Dockerfile to build an image and sent it to docker hub registry which is then been pulled in manifest file `deployment.yaml` for deployment.

---

## 5. Scalability

To ensure scalability, I have used HPA (Horizontal Pod Autoscaler). Initially only 2 replicas are created in deployment but as soon as requests are increased the hpa will automatically take care of increasing the pods.  

The Horizontal Pod Autoscaler is configured to monitor CPU utilization of the CORS proxy pods and increase the number of replicas when CPU usage exceeds a defined threshold. For example, if average CPU usage per pod exceeds 70%, HPA will incrementally scale up until the load is distributed evenly. With the current configuration and sufficient node resources, the deployment can scale to handle bursts up to ~1000 requests per second by adding more pods.

To ensure that the service can handle up to 1000 requests per second. This was estimated based on the average CPU/memory footprint per request measured locally, multiplied by the maximum pod count defined in the HPA. The AKS node pool size and pod resource limits are set to accommodate enough pods to process ~1000 RPS with headroom. In a real scenario, load testing should be performed to fine-tune limits and verify actual throughput.


<img width="2302" height="1318" alt="image" src="https://github.com/user-attachments/assets/9b63e3f6-8297-4e80-96fa-7a8dfb194c68" />
<img width="1291" height="603" alt="image" src="https://github.com/user-attachments/assets/4b8b2845-03ee-42a8-93a0-2179a77ced3c" />




## 6. Load Testing

skipped

---

## 7. Documentation and Deliverables

To perform the end to end setup just hit the `ci.yml` pipeline and it will take of itself.  

Few things to consider:
```bash
az login —-> get the subscription id which will be needed for next step

az ad sp create-for-rbac --name "github-actions-sp" --role Contributor --scopes /subscriptions/<subcription id from above> —sdk-auth
```

### Explanation

`ad` ->  active directory 
`sp` -> service principal ( a non-human identity that can log in to Azure)
`Github-actions-sp` -> name for your service principal (can be anything)
`—role Contributor` ->grants this service principal Contributor permissions (can create, update, and delete most resources, but not manage access(grant permissions to another user)).
`--scopes /subscriptions/<subcription id from above>` -> limits the permissions to only that subscription.
`—sdk-auth` ->outputs the credentials in a JSON format that GitHub Actions can directly use with azure login. 


The output is stored in secrets as AZURE_CREDENTIALS.

More screenshots of how the iAC created the two resource groups.

<img width="2382" height="1218" alt="image" src="https://github.com/user-attachments/assets/7a214aeb-8024-4ecc-8da5-60fdfd731bec" />

<img width="2382" height="970" alt="image" src="https://github.com/user-attachments/assets/b7fd747f-0cbd-4123-a8c8-398dc2ae80ab" />

---

##Limitations:

- No load testing has been performed, so the actual maximum sustainable RPS is unverified.

- HPA scales pods, but node pool scaling is not yet automated (Cluster Autoscaler is not enabled), so capacity could be capped by available nodes.

- Currently scales only on CPU; high RPS with low CPU but high network usage might not trigger scaling.

- No advanced caching or rate limiting is implemented, which could cause backend strain under extreme load.

- CORS proxy itself can become a bottleneck if request processing overhead is high.

---

##  Further steps:

- Enable Cluster Autoscaler to automatically add more nodes when HPA requires additional capacity.

- Tune pod resource requests/limits to maximize packing efficiency on nodes.

- Use KEDA with custom metrics (e.g., request count from Prometheus) to scale based on actual traffic instead of CPU alone.

- Deploy multiple replicas across availability zones to improve resilience and throughput.

- Introduce caching layers (e.g., Redis, CDN) to reduce backend load for repeated requests.

- Optimize application code and networking (e.g., keep-alive, gzip compression) to lower per-request resource usage.

- Perform load tests and adjust scaling thresholds to handle sustained high RPS without latency spikes.

