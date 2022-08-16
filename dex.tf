# Create Dex

data "kustomization_overlay" "dex" {
  config_map_generator {
    name     = "dex"
    behavior = "merge"
    literals = [
      "config.yaml=${templatefile(
        "${path.module}/templates/dex_config_map_overlay.tftpl",
        {
          dex_user_email = var.dex_user_email,
          dex_user_hash  = var.dex_user_hash,
          dex_user_name  = var.dex_user_name,
          dex_user_id    = var.dex_user_id,
        }
      )}"
    ]
  }

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
