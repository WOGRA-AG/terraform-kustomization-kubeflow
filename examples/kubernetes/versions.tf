terraform {
  required_providers {
    kustomization = {
      source  = "kbst/kustomization"
      version = ">= 0.7.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13.1"
    }
  }

  required_version = "~> 1.1"
}
