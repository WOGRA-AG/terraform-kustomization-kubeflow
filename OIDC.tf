# Create OpenID Connect service and configurations
data "kustomization_overlay" "oidc" {
  resources = [
    "github.com/kubeflow/manifests.git/common/oidc-authservice/base?ref=${var.kf_version}",
  ]
  patches {
    target {
      kind      = "ConfigMap"
      namespace = "istio-system"
      name      = "oidc-authservice-parameters"
    }
    patch = file("${path.module}/manifests/letsencrypt/oidc-authservice-parameters.yaml")
  }
}

resource "kustomization_resource" "oidc" {
  for_each = data.kustomization_overlay.oidc.ids
  manifest = replace(data.kustomization_overlay.oidc.manifests[each.value], "SKIP_AUTH_URI: /dex", "SKIP_AUTH_URI: /dex /cert-manager /.well-known /.well-known/acme-challenge")

  depends_on = [
    kustomization_resource.istio-base,
    kustomization_resource.istio-ingress,
  ]
}
