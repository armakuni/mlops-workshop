terraform {
  source = ".//."
}

locals {
  region = "eu-west-2"
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${local.region}"
  default_tags {
    tags = {
      Owner       = "ross.parkin@armakuni.com"
      Description     = "MLOps-Intro"
    }
  }
}

EOF
}

remote_state {
    backend = "s3"
    config = {
        bucket         = "mlops-intro-remote-state"
        key            = "${path_relative_to_include()}/terraform.tfstate"
        region         = "${local.region}"
        dynamodb_table = "mlops-intro-remote-state"
        encrypt        = true
    }
}

inputs = {
    region = "${local.region}"
}