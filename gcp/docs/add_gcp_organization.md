# Overview

<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

This tutorial will guide you to deploy the required infrastructure of Falcon Cloud Security on GCP organization.

## Automated Configuration

If you trust on the beauty of automation, you can simply run one of the deployment scripts available on this repository.

## Register an Organization

```sh
chmod +x ./add-gcp-organization.sh
./add-gcp-organization.sh
```

In case you want to customize or modify any value or parameter, you can follow the along this documentation.

--------------------------------

## Project setup

1. Select the project where we should create our service account from the drop-down list.
2. Copy and execute the script below in the Cloud Shell to complete the project setup.

<walkthrough-project-setup></walkthrough-project-setup>

```sh
gcloud config set project <walkthrough-project-id/>
```

```sh
ORG_ID=$(gcloud organizations list --format 'value(ID)')
```

### Step 1: Enable the following GCP APIs

* Cloud Asset API
* Cloud Resource Manager API
* App Engine Admin API
* Cloud SQL Admin API
* Compute Engine API
* Cloud Logging API
* Cloud Functions API
* Apigee API
* Notebooks API
* Vertex AI API
* AlloyDB API
* Dataplex API
* DataStream Viewer API
* Cloud Memorystore Memcached Viewer API
* Cloud Memorystore Redis Viewer API
* Security Center Admin Viewer API

Enable required GCP APIs by the following command:

```sh
gcloud services enable cloudasset.googleapis.com cloudresourcemanager.googleapis.com appengine.googleapis.com sqladmin.googleapis.com compute.googleapis.com logging.googleapis.com firebase.googleapis.com cloudfunctions.googleapis.com apigee.googleapis.com notebooks.googleapis.com aiplatform.googleapis.com alloydb.googleapis.com dataplex.googleapis.com datastream.googleapis.com memcache.googleapis.com redis.googleapis.com securitycenter.googleapis.com --project <walkthrough-project-id/>
```

--------------------------------

### Step 2: Create a custom role containing the permissions below

* resourcemanager.projects.get
* resourcemanager.folders.get
* cloudasset.assets.exportResource
* cloudasset.assets.listResource
* cloudasset.assets.searchAllIamPolicies
* cloudasset.assets.searchAllResources
* cloudasset.assets.exportIamPolicy
* appengine.versions.get
* firebase.clients.list
* firebase.projects.get
* firebaseappcheck.services.get
* firebaseauth.configs.get
* firebasedatabase.instances.list
* cloudfunctions.functions.sourceCodeGet

 To create a custom role at the organization level, execute the following command:

```sh
gcloud iam roles create FalconCspmAccess --description="Role used to grant access from Falcon Cloud Security to GCP resources" --organization=$ORG_ID --permissions=alloydb.clusters.list,alloydb.clusters.get,alloydb.instances.list,alloydb.users.list,alloydb.backups.list,alloydb.backups.get,apigee.organizations.get,apigee.organizations.list,apigee.instances.list,apigee.apiproducts.list,appengine.versions.get,resourcemanager.projects.get,resourcemanager.folders.get,cloudasset.assets.exportResource,cloudasset.assets.listResource,cloudasset.assets.searchAllIamPolicies,cloudasset.assets.searchAllResources,cloudasset.assets.exportIamPolicy,cloudfunctions.functions.sourceCodeGet,dataplex.lakes.get,dataplex.lakes.list,firebase.clients.list,firebase.projects.get,firebaseappcheck.services.get,firebaseauth.configs.get,firebasedatabase.instances.list,aiplatform.metadataStores.get,aiplatform.metadataStores.list,aiplatform.notebookExecutionJobs.get,aiplatform.notebookExecutionJobs.list,aiplatform.notebookRuntimes.get,aiplatform.notebookRuntimes.list,aiplatform.pipelineJobs.get,aiplatform.pipelineJobs.list,aiplatform.schedules.get,aiplatform.locations.list,aiplatform.notebookRuntimeTemplates.get,aiplatform.notebookRuntimeTemplates.list,aiplatform.datasets.get,aiplatform.datasets.list,notebooks.instances.get,memcache.instances.get,memcache.instances.list,redis.clusters.get,redis.clusters.list,redis.instances.get,redis.instances.list,compute.instances.list,compute.instanceGroups.get,datastream.streams.get,datastream.streams.list,essentialcontacts.contacts.list,essentialcontacts.contacts.get,recommender.iamPolicyRecommendations.get,recommender.iamPolicyRecommendations.list,recommender.iamPolicyLateralMovementInsights.get,recommender.iamPolicyLateralMovementInsights.list,securitycenter.organizationsettings.get
```

--------------------------------

### Step 3: Create the CrowdStike service account

Create a custom Service Account used by Falcon to get access to GCP projects and resources.

```sh
gcloud iam service-accounts create crowdstike-cspm --description="GCP service account for connecting CrowdStrike Falcon to GCP" --display-name="CrowdStrike CSPM"
```

### Step 4: Generate a Service Account JSON key grant permissions for Falcon to assume the Service Account

```sh
gcloud iam service-accounts keys create crowdstike-cspm.json --iam-account=crowdstike-cspm@<walkthrough-project-id/>.iam.gserviceaccount.com
```

### Step 5: Grant CrowdStrike service account access to the project by binding the previously created role

```sh
gcloud alpha organizations add-iam-policy-binding $ORG_ID \
  --member=serviceAccount:crowdstike-cspm@<walkthrough-project-id/>.iam.gserviceaccount.com \
  --role="organizations/$ORG_ID/roles/FalconCspmAccess"
```

--------------------------------

## Upload the JSON key on Falcon console

To complete the deployment process, once the key has been created, follow the steps to configure the GCP Project:

1. Go to Falcon Console > Cloud security > Settings > Account registration.
2. Select GCP, click on the "Add new account" button and select "Register GCP organizations" and click Next.
3. Enter the GCP organization IDs you want to add to Falcon.
4. Select the "Create service account and upload key file" option.
5. Download the crowdstrike-cspm.json key file from cloud shell terminal.
6. Upload the .json key file we've created for our service account on GCP and click Next.
7. All instructions on this page have already been executed, click Validate to finish.

## Cleanup Environment

### Delete CrowdStrike Service Accounts

```sh
gcloud iam service-accounts delete crowdstike-cspm@<walkthrough-project-id/>.iam.gserviceaccount.com
```

### Delete CrowdStrike Custom Role

```sh
gcloud iam roles delete FalconCspmAccess --organization=$ORG_ID
```
