provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-937185187804" # este bucket precisa ser criado antes (nao é possivel criar pelo terraform)
    key = "state/terraform-iac/terraform.tfstate" # nome do arquivo tfstate
    region = "us-east-2"   
  }
}