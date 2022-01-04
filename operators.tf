data "kustomization_build" "training-operator" {
  path = "github.com/kubeflow/manifests.git/apps/training-operator/upstream/overlays/kubeflow?ref=${var.kf_version}"
}

resource "kustomization_resource" "training-operator" {
  for_each = var.deploy_pipelines || var.deploy_katib ? data.kustomization_build.training-operator.ids : []
  manifest = data.kustomization_build.training-operator.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-resources,
  ]
}

data "kustomization_build" "mpi-operator" {
  path = "github.com/kubeflow/manifests.git/apps/mpi-job/upstream/overlays/kubeflow?ref=${var.kf_version}"
}

resource "kustomization_resource" "mpi-operator" {
  for_each = var.deploy_pipelines || var.deploy_katib ? data.kustomization_build.mpi-operator.ids : []
  manifest = data.kustomization_build.mpi-operator.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-resources,
  ]
}