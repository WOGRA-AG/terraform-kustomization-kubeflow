terraform {
}

module "kubeflow" {
  source = "../../"

  dex_user_email = "my@example.com"
}
