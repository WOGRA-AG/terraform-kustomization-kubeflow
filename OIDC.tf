# Create OpenID Connect service and configurations
data "kustomization_overlay" "oidc" {
  resources = [
    "github.com/kubeflow/manifests.git/common/oidc-authservice/base?ref=${var.kf_version}",
  ]
}

resource "kustomization_resource" "oidc" {
  for_each = data.kustomization_overlay.oidc.ids
  manifest = data.kustomization_overlay.oidc.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-base,
    kustomization_resource.istio-ingress,
  ]
}
