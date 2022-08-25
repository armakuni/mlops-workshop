include "root" {
  path = find_in_parent_folders()
}

inputs = {
  artefact_source = "${get_terragrunt_dir()}/Dockerrun.aws.json"
  dockercfg_source = "${get_terragrunt_dir()}/dockercfg.json"
  app_version_name = "mlops_api"
}