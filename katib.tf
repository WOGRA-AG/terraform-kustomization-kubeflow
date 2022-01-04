# Create katib server
data "kustomization_build" "katib" {
  path = "github.com/kubeflow/manifests.git/apps/katib/upstream/installs/katib-with-kubeflow?ref=${var.kf_version}"
}

resource "kubectl_manifest" "katib" {
  for_each  = var.deploy_katib ? data.kustomization_build.katib.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.katib.manifests[each.value]))
  wait      = true

  depends_on = [
    kustomization_resource.istio-resources,
  ]
}