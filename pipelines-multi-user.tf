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
  for_each  = var.deploy_pipelines && var.multi_user ? data.kustomization_overlay.pipelines-metacontroller.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_overlay.pipelines-metacontroller.manifests[each.value]))
  wait      = true

  depends_on = [
    kustomization_resource.profiles,
  ]
}

data "kustomization_overlay" "pipelines-multi-user" {
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

resource "kubectl_manifest" "pipelines-multi-user" {
  for_each  = var.deploy_pipelines && var.multi_user ? data.kustomization_overlay.pipelines-multi-user.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_overlay.pipelines-multi-user.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.pipelines-metacontroller,
  ]
}

data "kustomization_build" "pipelines-multi-user-emissary" {
  path = "github.com/kubeflow/manifests.git/apps/pipeline/upstream/env/platform-agnostic-multi-user-emissary?ref=${var.kf_version}"
}

resource "kubectl_manifest" "pipelines-multi-user-emissary" {
  for_each  = var.deploy_pipelines && var.multi_user ? data.kustomization_build.pipelines-multi-user-emissary.ids : []
  yaml_body = yamlencode(jsondecode(data.kustomization_build.pipelines-multi-user-emissary.manifests[each.value]))
  wait      = true

  depends_on = [
    kubectl_manifest.pipelines-multi-user,
  ]
}

locals {
  label_key   = "application-crd-id"
  label_value = "kubeflow-pipelines"
}