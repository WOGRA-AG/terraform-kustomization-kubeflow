# Create Kubeflow Roles
data "kustomization_build" "roles" {
  path = "github.com/kubeflow/manifests.git/common/kubeflow-roles/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "roles" {
  for_each = data.kustomization_build.roles.ids
  manifest = data.kustomization_build.roles.manifests[each.value]

  depends_on = [
    kubectl_manifest.kubeflow-namespace
  ]
}
