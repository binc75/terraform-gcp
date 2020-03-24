provider "google" {
  # Next line needed only if you don't use export GOOGLE_CLOUD_KEYFILE_JSON=/path/to/cred.json
  # credentials = file("serviceaccount.json")
  project     = "terra-project-272016"
  region      = var.region
}
