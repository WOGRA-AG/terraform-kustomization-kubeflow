data "kustomization_build" "dashboard" {
  path = "github.com/kubeflow/manifests.git/apps/centraldashboard/upstream/overlays/istio?ref=${var.kf_version}"
}

resource "kustomization_resource" "dashboard" {
  for_each = var.deploy_dashboard ? data.kustomization_build.dashboard.ids : []
  manifest = data.kustomization_build.dashboard.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-resources,
  ]
}