#!/bin/bash
set -eo pipefail
mkdir -p lib/nodejs
rm -rf node_modules lib/nodejs/node_modules
npm install --production
mv node_modules lib/nodejs/
ARTIFACT_BUCKET=$(cat ../bucket-name.txt)
aws cloudformation package --template-file template.yml --s3-bucket $ARTIFACT_BUCKET --output-template-file out.yml
aws cloudformation deploy --template-file out.yml --stack-name blank-nodejs --capabilities CAPABILITY_NAMED_IAM
aws cloudformation describe-stack-resource --stack-name blank-nodejs --logical-resource-id function --query 'StackResourceDetail.PhysicalResourceId' --output text > function-name.txt
