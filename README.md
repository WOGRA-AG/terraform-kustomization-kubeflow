# Terraform Kustomization Kubeflow

This module was originally created by the ml research team at [WOGRA AG][] 
to deploy kubeflow as part of the [Os4ML][] project.

**This module is experimental and not 
for production use.**

[Terraform]: https://www.terraform.io
[WOGRA AG]: https://wogra.com/
[Os4ML]: https://github.com/WOGRA-AG/Os4ML

## Usage

To use this within Terraform, add a `module` block like:

```hcl
module "kubeflow" {
  source  = "WOGRA-AG/kubeflow/kustomization"
  version = "0.1.0"
}
```


For more details, see https://registry.terraform.io/modules/WOGRA-AG/kubeflow.

## Details

Depending on the input variables, the `terraform-kustomization-kubeflow` 
module creates the following resources:

- Kubeflow's istio
- Kubeflow Pipelines
- Kubeflow Central Dashboard
- Kubeflow Katib
- Kubeflow Notebooks 
- Kubeflow Tensorboard 
- Kubeflow Volumes Web App
- Kubeflow Serving
- Kubeflow Pipelines

Furthermore, istio ingress-gateway can be patched from NodePort to 
LoadBalancer.
