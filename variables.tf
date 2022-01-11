variable "kubernetes_config_path" {
  description = "Path to kubernetes config file"
  default     = "~/.kube/config"
}

variable "deploy_istio" {
  description = "Deploy Kubeflow's istio components and configuration"
  type        = bool
  default     = true
}

variable "deploy_pipelines" {
  description = "Deploy Kubeflow Pipelines Component"
  type        = bool
  default     = true
}

variable "deploy_dashboard" {
  description = "Deploy Kubeflow Central Dashboard Component"
  type        = bool
  default     = true
}

variable "deploy_katib" {
  description = "Deploy Kubeflow Katib Component"
  type        = bool
  default     = true
}

variable "deploy_notebooks" {
  description = "Deploy Kubeflow Notebooks Component"
  type        = bool
  default     = false
}

variable "deploy_tensorboard" {
  description = "Deploy Kubeflow Tensorboard Component"
  type        = bool
  default     = false
}

variable "deploy_volumes" {
  description = "Deploy Kubeflow Volumes Web App Component"
  type        = bool
  default     = false
}

variable "deploy_serving" {
  description = "Deploy Kubeflow Serving Component"
  type        = bool
  default     = false
}

variable "multi_user" {
  description = "Deploy Kubeflow Pipelines as multi-user Component"
  type        = bool
  default     = true
}

variable "istio_ingress" {
  description = "Patch istio ingress-gateway from NodePort to LoadBalancer"
  type        = bool
  default     = true
}

variable "kf_version" {
  description = "Version der Kubeflow Manifests unter https://github.com/kubeflow/manifests"
  type        = string
  default     = "master"
}