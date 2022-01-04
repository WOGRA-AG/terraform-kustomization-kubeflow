# Install the Admission Webhook for PodDefaults
data "kustomization_build" "webhook" {
  path = "github.com/kubeflow/manifests.git/apps/admission-webhook/upstream/overlays/cert-manager?ref=${var.kf_version}"
}

resource "kustomization_resource" "webhook" {
  for_each = var.deploy_notebooks ? data.kustomization_build.webhook.ids : []
  manifest = data.kustomization_build.webhook.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-resources,
  ]
}

# Create notebook server
data "kustomization_build" "notebooks" {
  path = "github.com/kubeflow/manifests.git/apps/jupyter/notebook-controller/upstream/overlays/kubeflow?ref=${var.kf_version}"
}

resource "kubectl_manifest" "notebooks" {
  for_each  = var.deploy_notebooks ? data.kustomization_build.notebooks.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.notebooks.manifests[each.value]))
  wait      = true

  depends_on = [
    kustomization_resource.webhook,
  ]
}

# Create notebook Ui server
data "kustomization_build" "notebooks-ui" {
  path = "github.com/kubeflow/manifests.git/apps/jupyter/jupyter-web-app/upstream/overlays/istio?ref=${var.kf_version}"
}

resource "kubectl_manifest" "notebooks-ui" {
  for_each  = var.deploy_notebooks ? data.kustomization_build.notebooks-ui.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.notebooks-ui.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.notebooks,
  ]
}