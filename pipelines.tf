# Manifests from https://github.com/kubeflow/manifests/tree/master/apps/pipeline/upstream/env/platform-agnostic-multi-user
data "kustomization_overlay" "pipelines-metacontroller" {
  resources = [
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/third-party/metacontroller/base?ref=${var.kf_version}",
  ]

  # Identifier for application manager to apply ownerReference.
  # The ownerReference ensures the resources get garbage collected
  # when application is deleted.
  common_labels = {
    (local.label_key) = local.label_value
  }

  # !!! If you want to customize the namespace,
  # please also update base/cache-deployer/cluster-scoped/cache-deployer-clusterrolebinding.yaml
  namespace = "kubeflow"
}

resource "kubectl_manifest" "pipelines-metacontroller" {
  for_each  = var.deploy_pipelines ? data.kustomization_overlay.pipelines-metacontroller.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_overlay.pipelines-metacontroller.manifests[each.value]))
  wait      = true

  depends_on = [
    kustomization_resource.profiles,
  ]
}

data "kustomization_overlay" "pipelines" {
  resources = [
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/third-party/metacontroller/base?ref=${var.kf_version}",
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/third-party/mysql/base?ref=${var.kf_version}",
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/third-party/mysql/options/istio?ref=${var.kf_version}",
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/third-party/minio/base?ref=${var.kf_version}",
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/third-party/minio/options/istio?ref=${var.kf_version}",
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/base/installs/multi-user?ref=${var.kf_version}",
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/base/metadata/base?ref=${var.kf_version}",
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/base/metadata/options/istio?ref=${var.kf_version}",
    "github.com/kubeflow/manifests.git/apps/pipeline/upstream/third-party/argo/installs/cluster?ref=${var.kf_version}",
  ]

  # Identifier for application manager to apply ownerReference.
  # The ownerReference ensures the resources get garbage collected
  # when application is deleted.
  common_labels = {
    (local.label_key) = local.label_value
  }

  # !!! If you want to customize the namespace,
  # please also update base/cache-deployer/cluster-scoped/cache-deployer-clusterrolebinding.yaml
  namespace = "kubeflow"
}

resource "kubectl_manifest" "pipelines" {
  for_each  = var.deploy_pipelines ? data.kustomization_overlay.pipelines.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_overlay.pipelines.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.pipelines-metacontroller,
  ]
}

data "kustomization_build" "pipelines-multi-user-pns" {
  path = "github.com/kubeflow/manifests.git/apps/pipeline/upstream/env/platform-agnostic-multi-user-pns?ref=${var.kf_version}"
}

resource "kubectl_manifest" "pipelines-multi-user-pns" {
  for_each  = var.deploy_pipelines ? data.kustomization_build.pipelines-multi-user-pns.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.pipelines-multi-user-pns.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.pipelines,
  ]
}

locals {
  label_key   = "application-crd-id"
  label_value = "kubeflow-pipelines"
}
