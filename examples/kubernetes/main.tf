terraform {
}

module "kubeflow" {
  source = "WOGRA-AG/kubeflow/kustomization"

  dex_user_email = "my@example.com"
}
