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
  default     = false
}

variable "deploy_notebooks" {
  description = "Deploy Kubeflow Notebooks Component"
  type        = bool
  default     = true
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

variable "istio_ingress_load_balancer" {
  description = "Patch istio ingress-gateway from NodePort to LoadBalancer"
  type        = bool
  default     = false
}

variable "kf_version" {
  description = "Kubeflow Kustomize manifests version, see https://github.com/kubeflow/manifests"
  type        = string
  default     = "v1.5.0"
}

variable "dex_user_email" {
  description = "Dex static password user email for login"
  type        = string
  default     = "user@example.com"
}

variable "user_profile_name" {
  description = "Name of user profile"
  type        = string
  default     = "kubeflow-user-example-com"
}

variable "dex_user_hash" {
  description = "Dex static password bcrypt hash of user password"
  type        = string
  default     = "$2y$12$4K/VkmDd1q1Orb3xAt82zu8gk7Ad6ReFR4LCP9UeYE90NLiN9Df72"
}

variable "dex_user_name" {
  description = "Dex static password user name"
  type        = string
  default     = "user"
}

variable "dex_user_id" {
  description = "Dex static password user id"
  type        = string
  default     = "15841185641784"
}

variable "letsencrypt_mail" {
  description = "letsencrypt account email"
  type        = string
  default     = "letsencrypt@example.com"
}

variable "kubeflow_dns_name" {
  description = "kubeflow dns name"
  type        = string
  default     = "kubeflow.example.com"
}

variable "provide_tls" {
  description = "provide letsencrypt tls certificate"
  type        = bool
  default     = false
}

variable "external_ip" {
  description = "External IP for the ingress-gateway"
  default     = "127.0.0.1"
}