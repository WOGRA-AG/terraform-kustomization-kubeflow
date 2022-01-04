data "kustomization_build" "cert-manager-base" {
  path = "github.com/kubeflow/manifests.git/common/cert-manager/cert-manager/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "cert-manager-base" {
  for_each = data.kustomization_build.cert-manager-base.ids
  manifest = data.kustomization_build.cert-manager-base.manifests[each.value]
}

resource "time_sleep" "wait-cert-manager-base" {
  depends_on      = [kustomization_resource.cert-manager-base]
  create_duration = "20s"
}

data "kustomization_build" "cert-manager-issuer" {
  path = "github.com/kubeflow/manifests.git/common/cert-manager/kubeflow-issuer/base?ref=${var.kf_version}"
}

resource "kubectl_manifest" "cert-manager-issuer" {
  for_each  = data.kustomization_build.cert-manager-issuer.ids
  yaml_body = yamlencode(jsondecode(data.kustomization_build.cert-manager-issuer.manifests[each.value]))
  wait      = true
  depends_on = [
    time_sleep.wait-cert-manager-base,
    kustomization_resource.cert-manager-base,
  ]
}
