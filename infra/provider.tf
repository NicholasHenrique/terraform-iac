provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-tf-nicholas-henrique-de" # este bucket precisa ser criado antes (nao é possivel criar pelo terraform)
    key = "state/terraform-iac/terraform.tfstate" # nome do arquivo tfstate
    region = "us-east-2"   
  }
}