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
    "resourcemanager.projects.get",
    "cloudasset.assets.exportResource",
    "cloudasset.assets.listResource",
    "cloudasset.assets.searchAllIamPolicies",
    "cloudasset.assets.searchAllResources",
    "cloudasset.assets.exportIamPolicy",
    "appengine.versions.get",
    "firebase.clients.list",
    "firebase.projects.get",
    "firebaseappcheck.services.get",
    "firebaseauth.configs.get",
    "firebasedatabase.instances.list",
    "cloudfunctions.functions.sourceCodeGet"
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