#!/bin/bash
set -e

# Parse command line arguments
while getopts ":f:" opt; do
    case $opt in
        f) folder_id="$OPTARG" ;;
        \?) echo "Invalid option -$OPTARG" >&2; usage ;;
    esac
done

FOLDER_ID=$folder_id 
GCP_PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2> /dev/null)
ORG_ID=$(gcloud organizations list --format 'value(ID)')


# This script grants service account access to your GCP projects/folders/organizations for Falcon Horizon integration:
# First, enable the required service API in the service account's project

gcloud services enable cloudasset.googleapis.com cloudresourcemanager.googleapis.com appengine.googleapis.com sqladmin.googleapis.com compute.googleapis.com logging.googleapis.com firebase.googleapis.com cloudfunctions.googleapis.com --project $GCP_PROJECT_ID

# Create a CrowdStrike CSPM Service Account
echo "Deploying CrowdStrike CSPM Service Account..."
gcloud iam service-accounts create crowdstike-cspm --description="GCP service account for connecting CrowdStrike Falcon to GCP" --display-name="CrowdStrike CSPM"
CROWDSTRIKE_CSPM_SA_EMAIL=$(gcloud iam service-accounts list --filter=crowdstike-cspm --format="value(EMAIL)")
echo "CrowdStrike CSPM Service Account created"
echo $CROWDSTRIKE_CSPM_SA_EMAIL

# Generate a Service Account JSON key
echo "Generating JSON file..."
gcloud iam service-accounts keys create crowdstike-cspm.json --iam-account=$CROWDSTRIKE_CSPM_SA_EMAIL
serviceAccountKeyJson=$(cat crowdstike-cspm.json)

# Download Service Account JSON key
KEY_ID=$(gcloud iam service-accounts keys list --iam-account=$CROWDSTRIKE_CSPM_SA_EMAIL --format 'value(KEY_ID)')
gcloud beta iam service-accounts keys get-public-key $KEY_ID \
    --iam-account=$CROWDSTRIKE_CSPM_SA_EMAIL \
    --output-file=crowdstike-cspm.json

# Create custom role
gcloud iam roles create FalconCspmAccess --description="Role used to grant access from Falcon Cloud Security to GCP resources" --organization=$ORG_ID --permissions=resourcemanager.projects.get,resourcemanager.folders.get,cloudasset.assets.exportResource,cloudasset.assets.listResource,cloudasset.assets.searchAllIamPolicies,cloudasset.assets.searchAllResources,cloudasset.assets.exportIamPolicy,appengine.versions.get,firebase.clients.list,firebase.projects.get,firebaseappcheck.services.get,firebaseauth.configs.get,firebasedatabase.instances.list,cloudfunctions.functions.sourceCodeGet

# Grant CrowdStrike service account access to the project
gcloud resource-manager folders add-iam-policy-binding $FOLDER_ID \
  --member=serviceAccount:$CROWDSTRIKE_CSPM_SA_EMAIL \
  --role="organizations/$ORG_ID/roles/FalconCspmAccess"

echo "Service Acocunt and permissions have been configured successfully. Go to your Falcon console to finish the configuration."