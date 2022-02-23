# Create Dex

data "template_file" "config_yaml" {
  template = <<-EOT
    issuer: http://dex.auth.svc.cluster.local:5556/dex
    storage:
      type: kubernetes
      config:
        inCluster: true
    web:
      http: 0.0.0.0:5556
    logger:
      level: "debug"
      format: text
    oauth2:
      skipApprovalScreen: true
    enablePasswordDB: true
    staticPasswords:
    - email: ${var.dex_user_email}
      hash: ${var.dex_user_hash}
      # https://github.com/dexidp/dex/pull/1601/commits
      # FIXME: Use hashFromEnv instead
      username: ${var.dex_user_name}
      userID: "${var.dex_user_id}"
    staticClients:
    # https://github.com/dexidp/dex/pull/1664
    - idEnv: OIDC_CLIENT_ID
      redirectURIs: ["/login/oidc"]
      name: 'Dex Login Application'
      secretEnv: OIDC_CLIENT_SECRET
  EOT
}

data "kustomization_overlay" "dex" {
  config_map_generator {
    name     = "dex"
    behavior = "merge"
    literals = [
      "config.yaml=${data.template_file.config_yaml.rendered}"
    ]
  }

  resources = [
    "github.com/kubeflow/manifests.git/common/dex/overlays/istio?ref=${var.kf_version}",
  ]
}

resource "kustomization_resource" "dex" {
  for_each = data.kustomization_overlay.dex.ids
  manifest = data.kustomization_overlay.dex.manifests[each.value]

  depends_on = [
    kustomization_resource.istio-base,
    kustomization_resource.istio-ingress,
  ]
}
