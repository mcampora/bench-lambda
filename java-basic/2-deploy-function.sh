#!/bin/bash
set -eo pipefail
ARTIFACT_BUCKET=$(cat ../bucket-name.txt)
TEMPLATE=template-mvn.yml
mvn package
aws cloudformation package --template-file $TEMPLATE --s3-bucket $ARTIFACT_BUCKET --output-template-file out.yml
aws cloudformation deploy --template-file out.yml --stack-name java-basic --capabilities CAPABILITY_NAMED_IAM
aws cloudformation describe-stack-resource --stack-name java-basic --logical-resource-id function --query 'StackResourceDetail.PhysicalResourceId' --output text > function-name.txt

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
