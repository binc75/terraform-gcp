# Variables
# These variable can be overwritten with:
#   export TF_VAR_gce_ssh_pub_key_file=/home/nbianchi/.ssh/id_ed25519.pub
variable "gce_ssh_user" {default = "nbianchi"}
variable "gce_ssh_pub_key_file" {default = "~/.ssh/id_rsa.pub"}
variable "region" {default="europe-west6"}
variable "zone" {default="europe-west6-b"}
