# Create Dex
data "kustomization_overlay" "dex" {
  resources = [
    "github.com/kubeflow/manifests.git/common/dex/overlays/istio?ref=${var.kf_version}",
  ]
}

resource "kustomization_resource" "dex" {
  for_each = data.kustomization_overlay.dex.ids
  manifest = data.kustomization_overlay.dex.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-base,
    kustomization_resource.istio-ingress,
  ]
}
