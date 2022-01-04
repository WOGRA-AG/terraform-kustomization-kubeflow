# Create istio namespace
data "kustomization_build" "istio-namespace" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-9/istio-namespace/base?ref=${var.kf_version}"
}

resource "kubectl_manifest" "istio-namespace" {
  for_each  = var.deploy_istio ? data.kustomization_build.istio-namespace.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.istio-namespace.manifests[each.value]))

  wait = true
  depends_on = [
    kustomization_resource.cert-manager-base,
    kubectl_manifest.cert-manager-issuer,
  ]
}

# Add Istio certificates
data "kustomization_build" "istio-crds" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-9/istio-crds/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "istio-crds" {
  for_each   = var.deploy_istio ? data.kustomization_build.istio-crds.ids : []
  manifest   = data.kustomization_build.istio-crds.manifests[each.value]
  depends_on = [kubectl_manifest.istio-namespace]
}

# Create Istio base installation
data "kustomization_build" "istio-base" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-9/istio-install/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "istio-base" {
  for_each = var.deploy_istio && !var.istio_ingress ? data.kustomization_build.istio-base.ids : []
  manifest = data.kustomization_build.istio-base.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-crds
  ]
}

data "kustomization_overlay" "istio-ingress" {
  resources = [
    "github.com/kubeflow/manifests.git/common/istio-1-9/istio-install/base?ref=${var.kf_version}",
  ]

  patches {
    target = {
      kind      = "Service"
      namespace = "istio-system"
      name      = "istio-ingressgateway"
    }
    patch = <<-EOF
      apiVersion: v1
      kind: Service
      metadata:
        name: istio-ingressgateway
        namespace: istio-system
      spec:
        type: LoadBalancer
    EOF
  }
}

resource "kustomization_resource" "istio-ingress" {
  for_each = var.deploy_istio && var.istio_ingress ? data.kustomization_overlay.istio-ingress.ids : []
  manifest = data.kustomization_overlay.istio-ingress.manifests[each.value]
  depends_on = [
    kustomization_resource.istio-crds,
  ]
}

# Create Istio Resources
data "kustomization_build" "istio-resources" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-9/kubeflow-istio-resources/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "istio-resources" {
  for_each = data.kustomization_build.istio-resources.ids
  manifest = data.kustomization_build.istio-resources.manifests[each.value]
  depends_on = [
    kustomization_resource.roles
  ]
}