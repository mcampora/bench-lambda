#!/bin/bash
set -eo pipefail
STACK=java-basic
if [[ $# -eq 1 ]] ; then
    STACK=$1
    echo "Deleting stack $STACK"
fi
FUNCTION=$(cat function-name.txt)
aws cloudformation delete-stack --stack-name $STACK
aws cloudformation wait stack-delete-complete --stack-name $STACK
echo "Deleted $STACK stack."

aws logs delete-log-group --log-group-name /aws/lambda/$FUNCTION; rm function-name.txt
echo "Deleted function log group (/aws/lambda/$FUNCTION)"

rm -f out.yml out.json
rm -rf build .gradle target
