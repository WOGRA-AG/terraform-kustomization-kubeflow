data "kustomization_build" "pipelines-single-user" {
  path = "github.com/kubeflow/manifests.git/apps/pipeline/upstream/env/platform-agnostic-emissary?ref=${var.kf_version}"
}

resource "kubectl_manifest" "pipelines-single-user" {
  for_each  = var.deploy_pipelines && !var.multi_user ? data.kustomization_build.pipelines-single-user.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.pipelines-single-user.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.kubeflow-namespace,
  ]
}