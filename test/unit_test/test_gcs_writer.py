"""Unit Test: GCP GCS Medallion Bucket Write

Verifies write/read access to the GCP Data Lake bronze, silver, and gold GCS
buckets using only a short-lived OAuth access token exported by Terraform or the
GitHub Actions workflow.

Local Testing Steps:
```
terraform -chdir=./test init && \
terraform -chdir=./test apply -auto-approve

export BRONZE_BUCKET_NAME=$(terraform -chdir=./test output -raw bronze_bucket_name)
export SILVER_BUCKET_NAME=$(terraform -chdir=./test output -raw silver_bucket_name)
export GOLD_BUCKET_NAME=$(terraform -chdir=./test output -raw gold_bucket_name)
export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth application-default print-access-token)

python3 -m pytest test/unit_test -m "github and oidc" -rs

terraform -chdir=./test destroy -auto-approve
```
"""

import asyncio
import json
import logging
import os
import uuid

import gcsfs
import pytest
from google.oauth2.credentials import Credentials


BUCKET_ENV_VARS = {
    "bronze": "BRONZE_BUCKET_NAME",
    "silver": "SILVER_BUCKET_NAME",
    "gold": "GOLD_BUCKET_NAME",
}


def _required_env(name):
    value = os.getenv(name)
    if not value:
        pytest.skip(f"Required environment variable is not set: {name}")
    return value


def _medallion_buckets():
    return [(layer, _required_env(env_var)) for layer, env_var in BUCKET_ENV_VARS.items()]


def _gcs_project():
    return os.getenv("GOOGLE_CLOUD_PROJECT") or os.getenv("GOOGLE_PROJECT")


def _oauth_filesystem_kwargs():
    return {
        "project": _gcs_project(),
        "token": Credentials(token=_required_env("GOOGLE_OAUTH_ACCESS_TOKEN")),
    }


def _write_blob(fs, path, payload):
    with fs.open(path, "w") as file:
        file.write(json.dumps(payload))


def _read_blob(fs, path):
    with fs.open(path, "rb") as file:
        return json.loads(file.read())


async def _verify_bucket_write(layer, bucket_name, payload, **filesystem_kwargs):
    fs = gcsfs.GCSFileSystem(**filesystem_kwargs)
    path = f"gs://{bucket_name}/test/{layer}-{uuid.uuid4()}.json"
    layer_payload = {**payload, "layer": layer}

    await asyncio.to_thread(_write_blob, fs, path, layer_payload)
    result = await asyncio.to_thread(_read_blob, fs, path)

    assert result["test_value"] == layer_payload["test_value"]
    assert result["layer"] == layer


async def _verify_medallion_bucket_writes(payload, **filesystem_kwargs):
    await asyncio.gather(
        *(
            _verify_bucket_write(layer, bucket_name, payload, **filesystem_kwargs)
            for layer, bucket_name in _medallion_buckets()
        )
    )


@pytest.mark.github
@pytest.mark.env
def test_gcp_env_gcs_write(payload=None):
    logging.info("Pytest | Test GCP GCS Write with OAuth Access Token")
    payload = payload or {"test_value": str(uuid.uuid4())}

    asyncio.run(_verify_medallion_bucket_writes(payload, **_oauth_filesystem_kwargs()))


@pytest.mark.github
@pytest.mark.oidc
def test_gcp_oidc_gcs_write(payload=None):
    logging.info("Pytest | Test GCP GCS Write with GitHub OIDC OAuth Access Token")
    payload = payload or {"test_value": str(uuid.uuid4())}

    asyncio.run(_verify_medallion_bucket_writes(payload, **_oauth_filesystem_kwargs()))
