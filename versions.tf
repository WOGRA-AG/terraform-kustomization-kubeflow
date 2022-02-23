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
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.2"
    }
    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }
  }

  required_version = "~> 1.0"
}