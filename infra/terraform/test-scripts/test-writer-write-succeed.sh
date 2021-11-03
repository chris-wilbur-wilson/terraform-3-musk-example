#!/bin/bash
set -eo pipefail

source_bucket_name=$(terraform output -raw source_bucket_name)
echo "Source bucket - ${source_bucket_name}"
destination_bucket_name=$(terraform output -raw destination_bucket_name)
echo "Destination bucket - ${destination_bucket_name}"
kms_key_id=$(terraform output -raw kms_key_id)
echo "KMS Key id - ${destination_bucket_name}"
bucket_reader_arn=$(terraform output -raw bucket_reader_arn)
echo "Bucket reader - ${bucket_reader_arn}"
bucket_writer_arn=$(terraform output -raw bucket_writer_arn)
echo "Bucket writer - ${bucket_writer_arn}"

echo current identity
aws sts get-caller-identity

echo Assumming ${bucket_writer_arn}
assumeRoleEnv=$(aws sts assume-role \
            --role-session-name="new-session" \
            --role-arn="${bucket_writer_arn}"\
            --output text \
            --query='Credentials.[
              join(`=`, [`AWS_ACCESS_KEY_ID`, AccessKeyId]),
              join(`=`, [`AWS_SECRET_ACCESS_KEY`, SecretAccessKey]),
              join(`=`, [`AWS_SESSION_TOKEN`, SessionToken])
          ]')

eval "export $assumeRoleEnv"

echo new identity
aws sts get-caller-identity

aws s3 cp /test-files/Canon_40D.jpg "s3://${source_bucket_name}/test-files/" --sse aws:kms --sse-kms-key-id ${kms_key_id}
