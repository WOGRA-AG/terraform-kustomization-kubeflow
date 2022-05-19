# Add Istio Custom Resources
data "kustomization_build" "istio-crds" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-11/istio-crds/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "istio-crds" {
  for_each = var.deploy_istio ? data.kustomization_build.istio-crds.ids : []
  manifest = data.kustomization_build.istio-crds.manifests[each.value]
}

# Create istio namespace
data "kustomization_build" "istio-namespace" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-11/istio-namespace/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "istio-namespace" {
  for_each = var.deploy_istio ? data.kustomization_build.istio-namespace.ids : []
  manifest = data.kustomization_build.istio-namespace.manifests[each.value]
}

# Create Istio base installation
data "kustomization_build" "istio-base" {
  path = "github.com/kubeflow/manifests.git/common/istio-1-11/istio-install/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "istio-base" {
  for_each = var.deploy_istio && !var.istio_ingress_load_balancer ? data.kustomization_build.istio-base.ids : []
  manifest = data.kustomization_build.istio-base.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-crds,
    kustomization_resource.istio-namespace
  ]
}

data "kustomization_overlay" "istio-ingress" {
  resources = [
    "github.com/kubeflow/manifests.git/common/istio-1-11/istio-install/base?ref=${var.kf_version}",
  ]

  patches {
    target {
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
        loadBalancerIP: ${var.external_ip}
    EOF
  }
}

resource "kustomization_resource" "istio-ingress" {
  for_each = var.deploy_istio && var.istio_ingress_load_balancer ? data.kustomization_overlay.istio-ingress.ids : []
  manifest = data.kustomization_overlay.istio-ingress.manifests[each.value]
  depends_on = [
    kustomization_resource.istio-crds,
    kustomization_resource.istio-namespace
  ]
}

# Create Istio Resources
data "kustomization_build" "istio-resources" {
  path = var.provide_tls ? "${path.module}/manifests/kubeflow-istio-resources" : "github.com/kubeflow/manifests.git/common/istio-1-11/kubeflow-istio-resources/base?ref=${var.kf_version}"
}

resource "kustomization_resource" "istio-resources" {
  for_each = data.kustomization_build.istio-resources.ids
  manifest = replace(data.kustomization_build.istio-resources.manifests[each.value], "$KUBEFLOW_DNS_NAME", var.kubeflow_dns_name)
  depends_on = [
    kustomization_resource.roles
  ]
}
