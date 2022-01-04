# Create Kubeflow namespace
data "kustomization_build" "kubeflow-namespace" {
  path = "github.com/kubeflow/manifests.git/common/kubeflow-namespace/base?ref=${var.kf_version}"
}

resource "kubectl_manifest" "kubeflow-namespace" {
  for_each  = data.kustomization_build.kubeflow-namespace.ids
  yaml_body = yamlencode(jsondecode(data.kustomization_build.kubeflow-namespace.manifests[each.value]))
  wait      = true
  depends_on = [
    kustomization_resource.istio-base,
    kustomization_resource.istio-ingress,
    kustomization_resource.cert-manager-base,
  ]
}

# Create User namespace
data "kustomization_build" "user-namespace" {
  path = "github.com/kubeflow/manifests.git/common/user-namespace/base?ref=${var.kf_version}"
}

resource "kubectl_manifest" "user-namespace" {
  for_each  = data.kustomization_build.user-namespace.ids
  yaml_body = yamlencode(jsondecode(data.kustomization_build.user-namespace.manifests[each.value]))
  wait      = true
  depends_on = [
    kustomization_resource.profiles,
    kustomization_resource.cert-manager-base,
  ]
}

# KnativeServing namespace
resource "kubectl_manifest" "serving-namespace" {
  count     = var.deploy_serving ? 1 : 0
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: knative-serving
  labels:
    serving.knative.dev/release: "v0.22.1"
YAML
  wait      = true
  depends_on = [
    kustomization_resource.istio-base,
    kubectl_manifest.kubeflow-namespace,
  ]
}

# KnativeEventing namespace
resource "kubectl_manifest" "eventing-namespace" {
  count     = var.deploy_serving ? 1 : 0
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: knative-eventing
  labels:
    eventing.knative.dev/release: "v0.22.1"
YAML
  wait      = true
  depends_on = [
    kustomization_resource.istio-base,
    kubectl_manifest.kubeflow-namespace,
  ]
}