data "kustomization_build" "volumes" {
  path = "github.com/kubeflow/manifests.git/apps/volumes-web-app/upstream/overlays/istio?ref=${var.kf_version}"
}

resource "kubectl_manifest" "volumes" {
  for_each  = var.deploy_volumes ? data.kustomization_build.volumes.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.volumes.manifests[each.value]))
  wait      = true

  depends_on = [
    kustomization_resource.istio-resources,
  ]
}