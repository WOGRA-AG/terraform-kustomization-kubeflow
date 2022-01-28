provider "kustomization" {
  kubeconfig_path = var.kubernetes_config_path
}

provider "kubectl" {
  config_path = var.kubernetes_config_path
}
