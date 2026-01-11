#!/bin/bash
set -eo pipefail
FUNCTION=$(cat function-name.txt)
LABEL=${1}
echo "" >  ../results/${LABEL}-${FUNCTION}.out
for i in {1..10}; do
  aws lambda invoke \
    --cli-binary-format raw-in-base64-out \
    --function-name "${FUNCTION}:1" \
    out \
    --payload '{"sleep": 0}' \
    --log-type Tail \
    --query 'LogResult' \
    --output text | base64 -d | grep 'REPORT RequestId' >> ../results/${LABEL}-${FUNCTION}.out
  sleep 1
done
cat ../results/${LABEL}-${FUNCTION}.out
