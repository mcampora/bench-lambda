#!/bin/bash
set -eo pipefail
STACK=java-basic
if [[ $# -eq 1 ]] ; then
    STACK=$1
    echo "Deleting stack $STACK"
fi
if [ -f bucket-name.txt ]; then
    ARTIFACT_BUCKET=$(cat bucket-name.txt)
    if [[ ! $ARTIFACT_BUCKET =~ lambda-artifacts-[a-z0-9]{16} ]] ; then
        echo "Bucket was not created by this application. Skipping."
    else
        aws s3 rb --force s3://$ARTIFACT_BUCKET; rm bucket-name.txt
        echo "Deleted deployment artifacts and bucket ($ARTIFACT_BUCKET)"
    fi
fi

rm -f out.yml out.json
rm -rf build .gradle target
