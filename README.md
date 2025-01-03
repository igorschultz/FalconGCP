# Falcon Cloud Security On-boarding

The first step in getting started using Cloud Security Posture Management (CSPM) is to register your cloud provider accounts with CrowdStrike Falcon. When registering, CSPM is granted limited read-only access to your cloud account.
Choose the option that best suits your needs and consult our official documentation if you have any questions. [US-1](https://falcon.crowdstrike.com/documentation/page/c9209855/register-a-gcp-account) [US-2](https://falcon.us-2.crowdstrike.com/documentation/page/c9209855/register-a-gcp-account) [EU-1](https://falcon.eu-1.crowdstrike.com/documentation/page/c9209855/register-a-gcp-account)

## Prerequisites

1. **Install supporting tools**
   - [Google Cloud SDK](https://cloud.google.com/sdk/docs/install-sdk)

2. **CrowdStrike Requirements**
   - CrowdStrike Falcon Cloud Security or Falcon Cloud Security with Containers subscriptions
   - One or more of these default roles:
      - Falcon Administrator
      - Cloud Security Manager
      - CSPM Manager

3. **GCP minimal IAM permissions**
   - serviceusage.services.enable
   - iam.serviceAccounts.create
   - iam.serviceAccounts.list
   - iam.serviceAccountKeys.create
   - iam.serviceAccountKeys.list
   - iam.serviceAccountKeys.get
   - iam.roles.create
   - resourcemanager.projects.setIamPolicy
   - resourcemanager.organizations.setIamPolicy
   - resourcemanager.folders.setIamPolicy
   - resourcemanager.projects.getIamPolicy
   - resourcemanager.organizations.getIamPolicy
   - resourcemanager.folders.getIamPolicy

## Installation

| Deployment Type | Link |
|:--| :--|
| **Register a Project** | [![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Figorschultz%2FFalconGCP.git&cloudshell_workspace=gcp&cloudshell_tutorial=docs/add_gcp_project.md) |
| **Register a Folder** | [![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Figorschultz%2FFalconGCP.git&cloudshell_workspace=gcp&cloudshell_tutorial=docs/add_gcp_folder.md) |
| **Register an Organization** | [![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Figorschultz%2FFalconGCP.git&cloudshell_workspace=gcp&cloudshell_tutorial=docs/add_gcp_organization.md) |
