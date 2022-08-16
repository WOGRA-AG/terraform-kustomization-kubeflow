terraform {
}

module "kubeflow" {
  source = "../../"

  dex_user_email = "user@example.com"
}
