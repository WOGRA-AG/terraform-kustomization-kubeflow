#Create Knative-serving

data "kustomization_build" "knative-serving" {
  path = "github.com/kubeflow/manifests.git/common/knative/knative-serving/base?ref=${var.kf_version}"
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

#Create Istio cluster local gateway
data "kustomization_build" "istio-cluster-local-gateway" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-9/cluster-local-gateway/base?ref=${var.kf_version}"
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

# Create Istio cluster local gateway
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

# Create kfserving server
data "kustomization_build" "kfserving" {
  path = "github.com/kubeflow/manifests.git/apps/kfserving/upstream/overlays/kubeflow?ref=${var.kf_version}"
}

resource "kubectl_manifest" "kfserving" {
  for_each  = var.deploy_serving ? data.kustomization_build.kfserving.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.kfserving.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.kubeflow-namespace,
    kubectl_manifest.serving-namespace,
    kubectl_manifest.knative-serving,
    kubectl_manifest.knative-eventing,
  ]
}
