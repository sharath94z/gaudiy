# Memos - Open Source, Self-hosted, Your Notes, Your Way (open source application used gaudiy assignment)

<img align="right" height="96px" src="https://www.usememos.com/logo-rounded.png" alt="Memos" />

An open-source, self-hosted note-taking solution designed for seamless deployment and multi-platform access. Experience effortless plain text writing with pain-free, complemented by robust Markdown syntax support for enhanced formatting.


Here's a detailed outline for your README.md tailored for the recruitment assignment. It incorporates all the required elements and ensures clarity and comprehensiveness.

## Gaudiy Challenge Statement
Design and implement a CI/CD pipeline for a microservices-based web application hosted on GCP, ensuring scalability, monitoring, logging, automation.

## Table of Contents
1. [Implementation Overview](#implementation-overview)
2. [Architectural Diagram](#architecture)
3. [Setup and Deployment](#setup-and-deployment)
4. [Infrastructure as Code (IaC)](#infrastructure-as-code-iac)
5. [Continuous Integration (CI)](#continuous-integration-ci)
6. [Continuous Deployment (CD)](#continuous-deployment-cd)
7. [Monitoring and Logging](#monitoring-and-logging)
8. [Security Considerations](#security-considerations)
9. [Assumptions](#assumptions)
10. [Design Decisions](#design-decisions)
11. [Setup Instructions](#setup-instructions)
---
<a id="implementation-overview"></a>
## Implementation Overview

* Web Application - Used a open source self-hosted note taking application developed using golang and uses mysql sqlite database.
* Infrastructure as Code - Uses Terraform provisioning tool to create and maintain GKE cluster.
* Continuous Integration & Continuous Deployment - CI/CD pipeline implemented using Github action. CI performs front & backend checks, docker image build, and deploy the code to Kubernetes cluster when merged PR to main branch.
* Docker - Created Dockerfile to build and push docker images to docker hub.
* Monitoring and logging - Datadog a cloud based monitoring solution is used to collect metrics, logs and other infrastructure telemetry data to detect and troubleshoot issues.
---
<a id="architecture"></a>
## Architectural Diagram
![gaudiy-arch-diagram.png](docs/images/gaudiy-arch-diagram.png)
---
<a id="setup-instructions"></a>
## Setup Instructions 

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
![img.png](docs/images/img.png)

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