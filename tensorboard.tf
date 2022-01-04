data "kustomization_build" "tensorboard-ui" {
  path = "github.com/kubeflow/manifests.git/apps/tensorboard/tensorboards-web-app/upstream/overlays/istio?ref=${var.kf_version}"
}

resource "kubectl_manifest" "tensorboard-ui" {
  for_each  = var.deploy_tensorboard ? data.kustomization_build.tensorboard-ui.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.tensorboard-ui.manifests[each.value]))
  wait      = true

  depends_on = [
    kustomization_resource.istio-resources,
  ]
}

data "kustomization_build" "tensorboard-controller" {
  path = "github.com/kubeflow/manifests.git/apps/tensorboard/tensorboard-controller/upstream/overlays/kubeflow?ref=${var.kf_version}"
}

resource "kubectl_manifest" "tensorboard-controller" {
  for_each  = var.deploy_tensorboard ? data.kustomization_build.tensorboard-controller.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.tensorboard-controller.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.tensorboard-ui,
  ]
}