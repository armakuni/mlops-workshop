include "root" {
  path = find_in_parent_folders()
}

inputs = {
  artefact_source = "${get_terragrunt_dir()}/Dockerrun.aws.${get_env("COMMIT_ID", "no-ref")}.json"
  dockercfg_source = "${get_terragrunt_dir()}/dockercfg.json"
  app_version_name = get_env("COMMIT_ID", "no-ref")
}