data "kustomization_build" "profiles" {
  path = "github.com/kubeflow/manifests.git/apps/profiles/upstream/overlays/kubeflow?ref=${var.kf_version}"
}

resource "kustomization_resource" "profiles" {
  for_each = data.kustomization_build.profiles.ids
  manifest = data.kustomization_build.profiles.manifests[each.value]

  depends_on = [
    kustomization_resource.roles,
    kustomization_resource.oidc,
  ]
}
