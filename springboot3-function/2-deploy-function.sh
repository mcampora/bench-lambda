#!/bin/bash
#set -eo pipefail

ARTIFACT_BUCKET=$(cat ../bucket-name.txt)
TEMPLATE=template.yml
FUNCTION_NAME=springboot3-function
ACCOUNT=$( aws sts get-caller-identity | jq -r '.Account' )

mvn clean package

# package and deploy my lambda function
aws cloudformation package --template-file ${TEMPLATE} --s3-bucket ${ARTIFACT_BUCKET} --output-template-file out.yml
aws cloudformation deploy --parameter-overrides ImageUriParameter=${REPO_URI}:latest --template-file out.yml --stack-name ${FUNCTION_NAME} --capabilities CAPABILITY_NAMED_IAM
aws cloudformation describe-stack-resource --stack-name ${FUNCTION_NAME} --logical-resource-id Function --query 'StackResourceDetail.PhysicalResourceId' --output text > function-name.txt
FUNCTION=$( cat function-name.txt )

if [ ${1} == "snap" ]
then
    echo ""
    echo "*** turn on snapstart ***"
    aws lambda update-function-configuration --function-name ${FUNCTION} \
        --snap-start ApplyOn=PublishedVersions \
        --no-paginate \
        --output text
    aws lambda wait function-updated-v2 --function-name ${FUNCTION}
fi

echo ""
echo "*** publish a version ***"
aws lambda publish-version --function-name ${FUNCTION} \
    --no-paginate \
    --output text
aws lambda wait published-version-active --function-name "${FUNCTION}:1"

#aws lambda update-function-code \
#    --function-name ${FUNCTION} \
#    --image-uri ${REPO_URI}:latest
