# Terraform Kustomization Kubeflow

The `terraform-kustomization-kubeflow` uses Kubeflow's Kustomize manifests (see
[Kubeflow/manifests][]) to install [Kubeflow][] on any [Kubernetes][] 
cluster. In addition to this we added 'Let’s Encrypt' as optional Certificate 
Authority (CA).

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
ingress-gateway can be patched from NodePort to LoadBalancer. Tls can be enabled.  
You have to provide your kubeflow-dns-name and letsencrypt email-address to automatically receive tls certificates.  
The standard Kubeflow version is `v1.5.0`.

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
k3d cluster create kubeflow-cluster
```

Nevertheless, there is a known issue with k3d. Please check the 'Known 
Issues' section below. If you want to do machine learning, GPUs are 
always an issue. Unfortunately, GPUs are known to be a topic of their own. 
For more information on how to use GPUs please visit the OS4ML [docs][].

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
`user@example.com` and password `12341234`. Override the module defaults to 
change these values. Keep in mind, that the password has to be hashed for 
dex, e.g.

```sh
python3 -c 'from passlib.hash import bcrypt; import getpass; print(bcrypt.using(rounds=12, ident="2y").hash(getpass.getpass()))'
```

## Known Issues
- As described in [Kubeflow/manifests][] the deploy may fail the first time.
  Please repeat `terraform apply` until it works.
- There are reported problems with installation on Arm. Please provide us 
  with error descriptions, e.g. open issues. In paralllel we plan to run it 
  on a Nvidia Jetson Nano, see roadmap.
- **IMPORTANT!** Although we recommend using k3d, there are problems with 
  kubernetes versions greater than 1.21.
  So, it is recommended and tested using the image k3s:v1.21.7-k3s1, e.g.
```sh
k3d cluster create --image rancher/k3s:v1.21.7-k3s1 my-kubeflow-cluster
```

## Roadmap
In the near future the following will happen:

- [ ] Splitting the state into smaller parts, perhaps by using multiple 
  modules. We think the state should be placed inside the cluster, but 
  currently it is too big to do so. (June 2022)
- [ ] Replace 'kubernetes' provider with 'kubectl' provider. Both provider 
  do basically the same thing. (July 2022)
- [ ] Installation on a Jetson Nano (ARMv8-64) including GPU support. (~~May~~ 
  August 2022)

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