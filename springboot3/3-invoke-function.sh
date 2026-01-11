#!/bin/bash
set -eo pipefail
FUNCTION=$(cat function-name.txt)
LABEL=${1}
echo "" >  ../results/${LABEL}-${FUNCTION}.out
for i in {1..10}; do
  aws lambda invoke --function-name "${FUNCTION}:1" \
    --cli-binary-format raw-in-base64-out \
    --payload file://event.json \
    --log-type Tail \
    --query 'LogResult' \
    --output text \
    out | base64 -d | grep 'REPORT RequestId' >> ../results/${LABEL}-${FUNCTION}.out
  sleep 1
done
cat ../results/${LABEL}-${FUNCTION}.out
