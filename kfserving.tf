# Create Knative-serving
data "kustomization_build" "knative-serving" {
  path = "github.com/kubeflow/manifests.git/common/knative/knative-serving/overlays/gateways?ref=${var.kf_version}"
}

resource "kubectl_manifest" "knative-serving" {
  for_each  = var.deploy_serving ? data.kustomization_build.knative-serving.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.knative-serving.manifests[each.value]))
  wait      = true
  depends_on = [
    kustomization_resource.istio-base,
    kubectl_manifest.serving-namespace,
    kubectl_manifest.kubeflow-namespace,
  ]
}

# Create Istio cluster local gateway
data "kustomization_build" "istio-cluster-local-gateway" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-11/cluster-local-gateway/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "istio-cluster-local-gateway" {
  for_each = var.deploy_serving ? data.kustomization_build.istio-cluster-local-gateway.ids : []
  manifest = data.kustomization_build.istio-cluster-local-gateway.manifests[each.value]

  depends_on = [
    kubectl_manifest.kubeflow-namespace,
    kubectl_manifest.serving-namespace,
    kubectl_manifest.knative-serving,
  ]
}

# knative-eventing
data "kustomization_overlay" "knative-eventing" {
  resources = [
    "github.com/kubeflow/manifests.git/common/knative/knative-eventing/base?ref=${var.kf_version}",
  ]
}

resource "kubectl_manifest" "knative-eventing" {
  for_each  = var.deploy_serving ? data.kustomization_overlay.knative-eventing.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_overlay.knative-eventing.manifests[each.value]))
  wait      = true
  depends_on = [
    kubectl_manifest.kubeflow-namespace,
    kubectl_manifest.serving-namespace,
    kubectl_manifest.eventing-namespace,
    kubectl_manifest.knative-serving,
    kustomization_resource.istio-cluster-local-gateway,
  ]
}

# Create kserve
data "kustomization_build" "kserve" {
  path = "github.com/kubeflow/manifests.git/contrib/kserve/kserve?ref=${var.kf_version}"
}

resource "kubectl_manifest" "kserve" {
  for_each  = var.deploy_serving ? data.kustomization_build.kserve.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.kserve.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.kubeflow-namespace,
    kubectl_manifest.serving-namespace,
    kubectl_manifest.knative-serving,
    kubectl_manifest.knative-eventing,
  ]
}

data "kustomization_build" "kserve-web-app" {
  path = "github.com/kubeflow/manifests.git/contrib/kserve/models-web-app/overlays/kubeflow?ref=${var.kf_version}"
}

resource "kubectl_manifest" "kserve-web-app" {
  for_each  = var.deploy_serving ? data.kustomization_build.kserve-web-app.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.kserve-web-app.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.kserve
  ]
}