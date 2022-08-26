include "root" {
  path = find_in_parent_folders()
}

inputs = {
  artefact_source = "${get_terragrunt_dir()}/code-${get_env("COMMIT_ID", "no-ref")}.zip"
  dockercfg_source = "${get_terragrunt_dir()}/dockercfg.json"
  app_version_name = get_env("COMMIT_ID", "no-ref")
}