#!/bin/bash
set -eo pipefail
FUNCTION=$(cat function-name.txt)
echo "" >  ../results/${FUNCTION}.out
for i in {1..10}; do
  aws lambda invoke --function-name ${FUNCTION} out --log-type Tail --query 'LogResult' --output text | base64 -d | grep 'REPORT RequestId' >> ../results/${FUNCTION}.out
  sleep 1
done
cat ../results/${FUNCTION}.out
