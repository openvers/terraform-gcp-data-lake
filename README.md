# Terraform GCP Data Lake Module

## Overview

This repository provides a modular, production-ready Terraform implementation for provisioning a secure, scalable GCP Data Lake. It includes:
- Medallion architecture GCS buckets (Bronze, Silver, Gold)
- Service Account impersonation for secure authentication
- IAM policies for access control
- Secure access patterns and lifecycle management

The modules are designed for flexibility and can be used for both development and production environments.

## Module Structure

- `modules/gcs_bucket/` – GCS bucket creation, versioning, encryption, lifecycle, and access control.
- `modules/gcp_kms_key` – KMS key creation and policy management

## Usage

```hcl
module "data_lake" {
  source = "github.com/openvers/terraform-gcp-data-lake"

  impersonate_service_account = "your-service-account-email"
  project_id                  = "your-gcp-project-id"
  bronze_bucket_name          = "my-bronze-bucket"
  silver_bucket_name          = "my-silver-bucket"
  gold_bucket_name            = "my-gold-bucket"
}
```

## Testing

A test harness is provided in the `test/` directory. It includes:
- Service account and OIDC federation setup for authentication.
- Automated creation of a sample file and upload to the bronze bucket using Terraform's `local_file` and `google_storage_bucket_object` resources.
- Output variables for integration with CI/CD pipelines.

### Prerequisites

Before running Terraform, configure a bootstrap Google Cloud service account that can create the service account and IAM resources managed by this module.


```bash
#[TODO] Provide documentation to GCP IAM Configuration

cat << 'EOF' > ~/creds/gcp.secrets.envrc
export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT_EMAIL="<service-account-email>"
export GOOGLE_WORKLOAD_IDENTITY_PROVIDER="<identity-provider-uri>"
export GOOGLE_WORKLOAD_IDENTITY_PROVIDER_ID="<identity-provider-resource-id>"
export GOOGLE_WORKLOAD_IDENTITY_POOL_ID="<identity-pool-id>"

export GOOGLE_OAUTH_ACCESS_TOKEN="$(
  gcloud auth application-default print-access-token \
    --impersonate-service-account="$GOOGLE_SERVICE_ACCOUNT_EMAIL
)"

export TF_API_TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials."app.terraform.io".token')
EOF
```

### Local Deployment Testing

```bash
gcloud auth application-default login \
  --impersonate-service-account="$GOOGLE_IMPERSONATE_SERVICE_ACCOUNT_EMAIL"

terraform login app.terraform.io

terraform -chdir=test init
terraform -chdir=test plan
terraform -chdir=test apply -auto-approve

export BRONZE_BUCKET_NAME=$(terraform -chdir=test output -raw bronze_bucket_name)
export SILVER_BUCKET_NAME=$(terraform -chdir=test output -raw silver_bucket_name)
export GOLD_BUCKET_NAME=$(terraform -chdir=test output -raw gold_bucket_name)

export GOOGLE_IMPERSONATE_SERVICE_ACCOUNT_EMAIL=$(terraform -chdir=test output -raw google_service_account)
export GOOGLE_OAUTH_ACCESS_TOKEN=$(terraform -chdir=test output -raw google_oauth_access_token)

python3 -m pytest test/unit_test -m "github and oidc" -rs

direnv reload
terraform -chdir=test destroy -auto-approve
```

### Manual Dispatch Testing

```bash
# Try the Terraform Read/Plan job first once the workflow is available.
act -j terraform-dispatch-plan \
  -e .github/local.json \
  -s GOOGLE_PROJECT \
  -s GOOGLE_IMPERSONATE_SERVICE_ACCOUNT_EMAIL \
  -s GOOGLE_OAUTH_ACCESS_TOKEN \
  -s GOOGLE_WORKLOAD_IDENTITY_PROVIDER \
  -s GOOGLE_WORKLOAD_IDENTITY_POOL_ID \
  -s TF_API_TOKEN \
  --remote-name $(git remote show)

act -j terraform-dispatch-apply \
  -e .github/local.json \
  -s GOOGLE_PROJECT \
  -s GOOGLE_IMPERSONATE_SERVICE_ACCOUNT_EMAIL \
  -s GOOGLE_OAUTH_ACCESS_TOKEN \
  -s GOOGLE_WORKLOAD_IDENTITY_PROVIDER \
  -s GOOGLE_WORKLOAD_IDENTITY_POOL_ID \
  -s TF_API_TOKEN \
  --remote-name $(git remote show)

act -j terraform-dispatch-destroy \
  -e .github/local.json \
  -s GOOGLE_PROJECT \
  -s GOOGLE_IMPERSONATE_SERVICE_ACCOUNT_EMAIL \
  -s GOOGLE_OAUTH_ACCESS_TOKEN \
  -s GOOGLE_WORKLOAD_IDENTITY_PROVIDER \
  -s GOOGLE_WORKLOAD_IDENTITY_POOL_ID \
  -s TF_API_TOKEN \
  --remote-name $(git remote show)
```

### Integration Testing

Integration workflow support will be added with the GitHub workflow definitions. Once available, use `act` to validate the full integration lifecycle locally.

```bash
# Create an artifact location to upload/download between steps locally.
mkdir /tmp/artifacts

# Run the full integration test once the workflow is available.
act -j terraform-integration-destroy \
  -e .github/local.json \
  -s GOOGLE_PROJECT \
  -s GOOGLE_IMPERSONATE_SERVICE_ACCOUNT_EMAIL \
  -s GOOGLE_OAUTH_ACCESS_TOKEN \
  -s GOOGLE_WORKLOAD_IDENTITY_PROVIDER \
  -s GOOGLE_WORKLOAD_IDENTITY_POOL_ID \
  -s TF_API_TOKEN \
  --remote-name $(git remote show) \
  --artifact-server-path /tmp/artifacts
```

### Unit Tests

Unit workflow support will be added with the GitHub workflow definitions. Once available, use `act` to run Terraform formatting, validation, and unit-style checks locally.

```bash
act -j terraform-unit-tests \
  -e .github/local.json \
  -s GOOGLE_PROJECT \
  -s GOOGLE_REGION \
  -s TF_API_TOKEN \
  --remote-name $(git remote show)
```

---

## License

See [LICENSE](./LICENSE) for details.
