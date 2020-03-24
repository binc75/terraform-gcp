# Terraform examples for GCP 
Repository of terraform's  GCP examples.

## Requirements
First of all you need to create an account on GPC and to create a project,  
enable the APIs (*APIs & Services* --> *Dashboard* --> *Enable APIS AND SERVICES* --> *Compute Engine*),  
then you need to create a service account in order to interact with the API.  
#### CLI
```bash
# Create project
gcloud projects create --name="terra-project" --enable-cloud-apis
# Set workspace to the new project
gcloud config set project $(gcloud projects list | grep terra-project- | awk {'print $1'})
```

### Adding credentials
In order to make requests against the GCP API, you need to authenticate.
The preferred method of provisioning resources with Terraform is to use a GCP service account, 
a "robot account" that can be granted a limited set of IAM permissions.

From the project page, select *IAM & Admin*, then *Service Account*.
Now click on *CREATE SERVICE ACCOUNT*, choose a name for the new account and give it *Project Owner* grants.
Next, download the JSON key file (Actions --> Create Key). Name it something you can remember,  
and store it somewhere secure on your machine.  
#### CLI
```bash
# Set var with gcp project ID
project_id=$(gcloud projects list | grep terra-project- | awk {'print $1'})

# Create service account
gcloud iam service-accounts create srv-account

# Grant the necessary roles for our service account to create a GKE cluster
# and the associated resources
gcloud projects add-iam-policy-binding  $project_id --member serviceAccount:srv-account@$project_id.iam.gserviceaccount.com --role roles/container.admin
gcloud projects add-iam-policy-binding  $project_id --member serviceAccount:srv-account@$project_id.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding  $project_id --member serviceAccount:srv-account@$project_id.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding  $project_id --member serviceAccount:srv-account@$project_id.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
### For full access (project owner grants, easy ;-))
### gcloud projects add-iam-policy-binding  $project_id --member serviceAccount:srv-account@$project_id.iam.gserviceaccount.com --role roles/owner

# Enable the Google Cloud APIs we will use 
# If you get an error about the billing follow the link in the error message
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com

# Download the key file
gcloud iam service-accounts keys create ~/credentials.json --iam-account=srv-account@$project_id.iam.gserviceaccount.com
```

You supply the key to Terraform using the environment variable *GOOGLE_CLOUD_KEYFILE_JSON*, 
setting the value to the location of the file.

``` bash
export GOOGLE_CLOUD_KEYFILE_JSON=~/credentials.json
export GOOGLE_PROJECT=$(gcloud config get-value project) # Optional
```
Remember to add this line to a startup file such as bash_profile or bashrc to store your credentials across sessions!

## Examples
Now explore one of the directories for examples!
