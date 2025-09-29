terraform {
  required_version = ">= 1.12.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.54.0"
    }
  }

  backend "s3" {
    bucket    = "aws-glue-terraform-state"
    key       = "dev/aws-glue.tfstate"
    region    = "us-west-2"
    encrypt   = true
  }
}
