Configure kubectl  command line access by running the following command:
```bash
gcloud container clusters get-credentials gaudiy-gke-cluster --zone asia-northeast1-a --project blissful-axiom-442117-s9
```

Create monitoring namespace
```bash
kubectl create namespace monitoring
```

install kubectx
```commandline
brew install kubectx
```

Install helm
```commandline
brew install helm
```

Install kubeopsview for cluster monitoring
```commandline
helm repo add k8s-at-home https://k8s-at-home.com/charts/
helm repo update
helm install kube-ops-view k8s-at-home/kube-ops-view -f ./deployments/helm_values/kubeopsview.yaml 
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=kube-ops-view,app.kubernetes.io/instance=kube-ops-view" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080
```
![img.png](docs/images/kubeopsview.png)

Setup datadog
```commandline
helm repo add datadog https://helm.datadoghq.com
helm install datadog-operator datadog/datadog-operator
kubectl create secret generic datadog-secret --from-literal api-key=***
kubectl apply -f deployments/datadog-agent.yaml
```

![datadog-dashboard.png](docs/images/datadog-dashboard.png)

Deploy memos application
```commandline
helm install memos -n applications deployments/helm_charts/memos
export POD_NAME=$(kubectl get pods --namespace applications -l "app.kubernetes.io/name=memos,app.kubernetes.io/instance=memos" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace applications $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace applications port-forward $POD_NAME 8080:$CONTAINER_PORT
```