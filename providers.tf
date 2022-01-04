provider "kustomization" {
  kubeconfig_path = "~/.kube/config"
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

provider "time" {}