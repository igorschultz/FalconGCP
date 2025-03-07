#!/bin/bash
set -e

GCP_PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2> /dev/null)

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
gcloud iam roles create FalconCspmAccess --description="Role used to grant access from Falcon Cloud Security to GCP resources" --project=$GCP_PROJECT_ID --permissions=alloydb.clusters.list,alloydb.clusters.get,alloydb.instances.list,alloydb.users.list,alloydb.backups.list,alloydb.backups.get,apigee.organizations.get,apigee.organizations.list,apigee.instances.list,apigee.apiproducts.list,appengine.versions.get,resourcemanager.projects.get,cloudasset.assets.exportResource,cloudasset.assets.listResource,cloudasset.assets.searchAllIamPolicies,cloudasset.assets.searchAllResources,cloudasset.assets.exportIamPolicy,cloudfunctions.functions.sourceCodeGet,dataplex.lakes.get,dataplex.lakes.list,firebase.clients.list,firebase.projects.get,firebaseappcheck.services.get,firebaseauth.configs.get,firebasedatabase.instances.list,aiplatform.metadataStores.get,aiplatform.metadataStores.list,aiplatform.notebookExecutionJobs.get,aiplatform.notebookExecutionJobs.list,aiplatform.notebookRuntimes.get,aiplatform.notebookRuntimes.list,aiplatform.pipelineJobs.get,aiplatform.pipelineJobs.list,aiplatform.schedules.get

# Grant CrowdStrike service account access to the project
gcloud alpha projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member=serviceAccount:$CROWDSTRIKE_CSPM_SA_EMAIL \
  --role="projects/$GCP_PROJECT_ID/roles/FalconCspmAccess"

echo "Service Acocunt and permissions have been configured successfully. Go to your Falcon console to finish the configuration."