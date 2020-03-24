# Terraform provider
provider "google" {
  # Next line needed only if you don't use export GOOGLE_CLOUD_KEYFILE_JSON=/path/to/cred.json
  # credentials = file("terratest-266509-d14302339e74.json")
  #
  # Project can be passed also by GOOGLE_PROJECT env variable
  project = "terra-project-272016"
  region  = "europe-west6"
  zone    = "europe-west6-a"
}
