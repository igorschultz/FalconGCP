variable "projectID" {
  type        = string
  description = "The GCP project ID you want to apply the deployment to."
  default     = ""
}

variable "orgID" {
  type        = string
  description = "The GCP organization ID"
  default     = ""

}

variable "gcpServicesList" {
  description = "Google APIs need to be enabled"
  type        = set(string)
  default = [
    "cloudasset.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "appengine.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "cloudfunctions.googleapis.com",
    "apigee.googleapis.com",
    "notebooks.googleapis.com",
    "aiplatform.googleapis.com",
    "alloydb.googleapis.com",
    "dataplex.googleapis.com",
    "datastream.googleapis.com",
    "memcache.googleapis.com",
    "redis.googleapis.com",
    "securitycenter.googleapis.com"
  ]
}
