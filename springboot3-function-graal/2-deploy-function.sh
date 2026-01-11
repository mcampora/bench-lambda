#!/bin/bash
#set -eo pipefail

ARTIFACT_BUCKET=$(cat ../bucket-name.txt)
TEMPLATE=template.yml
FUNCTION_NAME=springboot3-function-graal
ACCOUNT=$( aws sts get-caller-identity | jq -r '.Account' )

# build the docker image we will use to create a graalvm native image
docker buildx build \
    --platform linux/aarch64 \
    --provenance=false \
    -t graalvm-builder:latest \
    .
# launch the maven build using the docker image
docker run -it -v `pwd`:/build -v ~/.m2:/root/.m2 graalvm-builder:latest -c 'mvn clean -Pnative package -DskipTests'

# package and deploy my lambda function
aws cloudformation package --template-file ${TEMPLATE} --s3-bucket ${ARTIFACT_BUCKET} --output-template-file out.yml
aws cloudformation deploy --parameter-overrides ImageUriParameter=${REPO_URI}:latest --template-file out.yml --stack-name ${FUNCTION_NAME} --capabilities CAPABILITY_NAMED_IAM
aws cloudformation describe-stack-resource --stack-name ${FUNCTION_NAME} --logical-resource-id Function --query 'StackResourceDetail.PhysicalResourceId' --output text > function-name.txt
FUNCTION=$( cat function-name.txt )

echo ""
echo "*** publish a version ***"
aws lambda publish-version --function-name ${FUNCTION} \
    --no-paginate \
    --output text
aws lambda wait published-version-active --function-name "${FUNCTION}:1"

#aws lambda update-function-code \
#    --function-name ${FUNCTION} \
#    --image-uri ${REPO_URI}:latest
