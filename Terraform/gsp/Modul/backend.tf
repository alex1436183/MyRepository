terraform {
  backend "gcs" {
    bucket = "my-gcp-busket-terraform-avl"
    prefix = "state/terraform.tfstate"
  }
}
