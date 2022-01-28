# Terraform Kustomization Kubeflow

The `terraform-kustomization-kubeflow` uses Kubeflow's Kustomize manifests (see
[Kubeflow/manifests][]) to install [Kubeflow][] on any [Kubernetes][] cluster.

## About The Module

Depending on the input variables, the module creates the following resources:

- Kubeflow istio (default)
- Kubeflow Pipelines (default)
- Kubeflow Central Dashboard (default)
- Kubeflow Katib (default)
- Kubeflow Notebooks (optional)
- Kubeflow Tensorboard (optional)
- Kubeflow Volumes Web App (optional)
- Kubeflow Serving (optional)

By default, Kubeflow multi-user pipelines are enabled. Furthermore, istio 
ingress-gateway can be patched from NodePort to LoadBalancer. The 
standard Kubeflow version is `v1.4.1`.

### Important
**The module is in an early stage of development. Thus, it is experimental and 
not for production use.**

## Getting Started
Nobody wants complicated installations. We neither, so we try to keep 
things as simple as possible. So how does it work?

### Prerequisites
In fact, all it takes is a running [Kubernetes][] cluster to get started.
With [k3d][] you can do it like this, for example

```sh
k3d cluster create os4ml-cluster
```

If you want to do machine learning, GPUs are always an issue. Unfortunately, 
GPUs are known to be a topic of their own. For more information on how to 
use GPUs please visit the OS4ML [docs][].

### Installation
In `./examples/kubernetes` you find a [Terraform][] script to install 
[Kubeflow][] on your configured [Kubernetes][] cluster. And this is how it 
works:

```sh
git clone https://github.com/WOGRA-AG/terraform-kustomization-kubeflow
cd terraform-kustomization-kubeflow/examples/kubernetes
terraform init
terraform apply -auto-approve
```

This takes a bit and offers the opportunity to get a coffee.

### Usage
You won't believe it, but in fact your [Kubernetes][] cluster hosts a 
fully functional [Kubeflow][] now. And that's how you get it:

```sh
kubectl port-forward -n istio-system svc/istio-ingressgateway 8000:80
```
Now, open `localhost:8000` for [Kubeflow][]. As described 
[here](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/),
the connection is terminated when the command is aborted. Whenever you are 
asked for credentials, there exists a standard user with email 
`user@example.com` and password `12341234`.

## Known Issues
- Currently there are problems with higher version of [Kubeflow][], i.e. 
  `>=v1.5.0`. We're working on that in near future. Nevertheless, we are 
  waiting for a stable [Kubeflow][] release first.

- As described in [Kubeflow/manifests][] the deploy may fail the first time.
  Please repeat `terraform apply` until it works.

## Roadmap
In the near future the following will happen:

1. [Kubeflow][]
   - [x] Support `>=v1.4.1`
   - [ ] Support `>=v1.5.0` (April 2022)
2. Features
   - [ ] Change standard user/password as input variable (February 2022)

## 	Acknowledgment
This module was originally created by the ml research team at [WOGRA AG][] 
to deploy kubeflow as part of the [Os4ML][] project.

[Os4ML][] is a project of the [WOGRA AG][] research group in cooperation 
with the German Aerospace Center and is funded by the Ministry of Economic 
Affairs, Regional Development and Energy as part of the High Tech Agenda 
of the Free State of Bavaria.

[Terraform]: https://terraform.io/
[Kubernetes]: https://kubernetes.io/
[Kubernetes/port-forward]: https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/
[Kubeflow]: https://www.kubeflow.org/
[Kubeflow/manifests]: https://github.com/kubeflow/manifests
[k3d]: https://k3d.io
[WOGRA AG]: https://www.wogra.com/
[Os4ML]: https://github.com/WOGRA-AG/Os4ML
[docs]: https://wogra-ag.github.io/os4ml-docs/
[WOGRA-AG/kubeflow/kustomization]: https://registry.terraform.io/modules/WOGRA-AG/kubeflow/kustomization/latest
[kbst/kustomize]: https://registry.terraform.io/providers/kbst/kustomize