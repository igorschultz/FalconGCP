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

resource "google_service_account" "falcon_service_account" {
  account_id   = "crowdstike-cspm"
  display_name = "Service Account for Falcon CSPM Access"
  project      = var.projectID
}

resource "google_service_account_key" "falcon_key" {
  service_account_id = google_service_account.falcon_service_account.name
  public_key_type    = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

# Save the private key to a local file
resource "local_file" "private_key_file" {
  content  = google_service_account_key.falcon_key.private_key
  filename = "${path.module}/falcon-private-key.json"
}

# List of roles to assign
locals {
  roles = [
    "roles/alloydb.viewer",
    "roles/apigee.readOnlyAdmin",
    "roles/appengine.appViewer",
    "roles/browser",
    "roles/cloudasset.viewer",
    "roles/cloudfunctions.developer",
    "roles/memcache.viewer",
    "roles/redis.viewer",
    "roles/compute.viewer",
    "roles/dataplex.viewer",
    "roles/datastream.viewer",
    "roles/essentialcontacts.viewer",
    "roles/firebaseappcheck.viewer",
    "roles/firebaseauth.viewer",
    "roles/firebasedatabase.viewer",
    "roles/iam.recommendationsViewer",
    "roles/securitycenter.adminViewer",
    "roles/aiplatform.viewer",
    "roles/artifactregistry.reader",
    "roles/storage.objectViewer"
  ]
}

# Assign roles to the service account at project level
resource "google_project_iam_member" "service_account_roles" {
  count   = length(local.roles)
  project = var.projectID
  role    = local.roles[count.index]
  member  = "serviceAccount:${google_service_account.falcon_service_account.email}"
}

