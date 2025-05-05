terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.15.0"
    }
  }
}

provider "google" {
  project = var.projectID
}

resource "google_project_service" "gcp_services" {
  project  = var.projectID
  for_each = var.gcpServicesList
  service  = each.value
}

resource "google_organization_iam_custom_role" "falcon_cspm_access_role" {
  org_id      = var.orgID
  role_id     = "falcon_cspm_access_role"
  description = "Role used to grant access from Falcon Cloud Security to GCP resources"
  title       = "falcon-cspm-access-role"
  permissions = [
    "alloydb.clusters.list",
    "alloydb.clusters.get",
    "alloydb.instances.list",
    "alloydb.users.list",
    "alloydb.backups.list",
    "alloydb.backups.get",
    "apigee.organizations.get",
    "apigee.organizations.list",
    "apigee.instances.list",
    "apigee.apiproducts.list",
    "appengine.versions.get",
    "resourcemanager.projects.get",
    "resourcemanager.folders.get",
    "cloudasset.assets.exportResource",
    "cloudasset.assets.listResource",
    "cloudasset.assets.searchAllIamPolicies",
    "cloudasset.assets.searchAllResources",
    "cloudasset.assets.exportIamPolicy",
    "cloudfunctions.functions.sourceCodeGet",
    "memcache.instances.get",
    "memcache.instances.list",
    "redis.clusters.get",
    "redis.clusters.list",
    "redis.instances.get",
    "redis.instances.list",
    "compute.instances.list",
    "compute.instanceGroups.get",
    "dataplex.lakes.get",
    "dataplex.lakes.list",
    "datastream.streams.get",
    "datastream.streams.list",
    "essentialcontacts.contacts.list",
    "essentialcontacts.contacts.get",
    "firebase.clients.list",
    "firebase.projects.get",
    "firebaseappcheck.services.get",
    "firebaseauth.configs.get",
    "firebasedatabase.instances.list",
    "recommender.iamPolicyRecommendations.get",
    "recommender.iamPolicyRecommendations.list",
    "recommender.iamPolicyLateralMovementInsights.get",
    "recommender.iamPolicyLateralMovementInsights.list",
    "securitycenter.organizationsettings.get",
    "aiplatform.metadataStores.get",
    "aiplatform.metadataStores.list",
    "aiplatform.notebookExecutionJobs.get",
    "aiplatform.notebookExecutionJobs.list",
    "aiplatform.notebookRuntimes.get",
    "aiplatform.notebookRuntimes.list",
    "aiplatform.pipelineJobs.get",
    "aiplatform.pipelineJobs.list",
    "aiplatform.schedules.get",
    "aiplatform.locations.list",
    "aiplatform.notebookRuntimeTemplates.get",
    "aiplatform.notebookRuntimeTemplates.list",
    "aiplatform.datasets.get",
    "aiplatform.datasets.list",
    "notebooks.instances.get"
  ]
}

resource "google_service_account" "falcon_service_account" {
  account_id   = "crowdstike-cspm"
  display_name = "Service Account for Falcon CSPM Access"
}

resource "google_service_account_key" "falcon_key" {
  service_account_id = google_service_account.falcon_service_account.name
  public_key_type    = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

# Save the private key to a local file
resource "local_file" "private_key_file" {
  content  = google_service_account_key.falcon_key.private_key
  filename = "falcon-private-key.json"
}

resource "google_organization_iam_binding" "falcon_organization_access" {
  org_id = var.orgID
  role   = "organizations/${var.orgID}/roles/falcon_cspm_access_role"

  members = [
    "serviceAccount:${google_service_account.falcon_service_account.email}",
  ]
}