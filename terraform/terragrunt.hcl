terraform {
  source = ".//."
}

locals {
  region = "eu-west-2"
  owner = "ross.parkin@armakuni.com"
  remote_state_name = "mlops-intro-remote-state-rp-new"
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
      Owner       = "${local.owner}"
      Description     = "MLOps-Intro"
    }
  }
}

EOF
}

remote_state {
    backend = "s3"
    config = {
        bucket         = "${local.remote_state_name}"
        key            = "${path_relative_to_include()}/terraform.tfstate"
        region         = "${local.region}"
        dynamodb_table = "${local.remote_state_name}"
        encrypt        = true
    }
}

inputs = {
    region = "${local.region}"
}