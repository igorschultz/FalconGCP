# Overview

<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

This tutorial will guide you to deploy the required infrastructure of Falcon Cloud Security on GCP organizations using Terraform.

--------------------------------

## Project setup

1. Select the project from the drop-down list.
2. Copy and execute the script below in the Cloud Shell to complete the project setup.

<walkthrough-project-setup></walkthrough-project-setup>

```sh
gcloud config set project <walkthrough-project-id/>
```

Execute the following command to get your organizations id and add it's value on your <walkthrough-editor-open-file filePath="terraform.tfvars">terraform.tfvars</walkthrough-editor-open-file> file.

```sh
ORG_ID=$(gcloud organizations list --format 'value(ID)')
echo $ORG_ID
```

### Configure Terraform Variables

Specify the following fields in <walkthrough-editor-open-file filePath="terraform.tfvars">terraform.tfvars</walkthrough-editor-open-file> and apply the Terraform template in the Cloud Shell:

1. **projectID** Specify the project id where you should create Falcon service account.
2. **orgID:** Specify your organizations id.

--------------------------------

### Apply the deployment

Our terraform template will be used to deploy the required infrastructure of Falcon Cloud Security for GCP. For more information about these requirement, see GCP requirements [us-1](https://falcon.crowdstrike.com/documentation/page/c9209855/register-a-gcp-account), [us-2](https://falcon.us-2.crowdstrike.com/documentation/page/c9209855/register-a-gcp-account) or [eu-1](https://falcon.eu-1.crowdstrike.com/documentation/page/c9209855/register-a-gcp-account)  

```sh
terraform init  && \
  terraform apply -var-file="terraform.tfvars" --auto-approve
```

> Please save `terraform.tfstate` and `terraform.tfvars` for managing the deployment. We recommend you use [remote configuration](https://developer.hashicorp.com/terraform/language/backend/remote) to keep your tfstate somewhere safe.

--------------------------------

## Upload the JSON key on Falcon console

To complete the deployment process, once the Terraform creates the infrastructure, follow the steps to configure the GCP Organizations:

1. Go to Falcon Console > Cloud security > Settings > Account registration.
2. Select GCP, click on the "Add new account" button and select "Register GCP organizations" and click Next.
3. Enter the GCP organization IDs you want to add to Falcon.
4. Select the "Create service account and upload key file" option.
5. Download the falcon-private-key.json key file from cloud shell terminal.
6. Upload the .json key file we've created for our service account on GCP and click Next.
7. All instructions on this page have already been executed, click Validate to finish.

## Cleanup Environment

### Delete CrowdStrike Infrastructure using Terraform

```sh
terraform destroy -var-file="terraform.tfvars" --auto-approve
```
