#!/bin/bash
set -eo pipefail
FUNCTION=$(cat function-name.txt)
LOG_GROUP="/aws/lambda/${FUNCTION}"
TIMESTAMP=$(($(date +%s) * 1000 - 5 * 60 * 1000))  # 5 minutes ago in milliseconds

echo "Invoking function ${FUNCTION} asynchronously..."
for i in {1..20}; do
  aws lambda invoke \
    --function-name "${FUNCTION}:1" \
    out \
    --invocation-type Event \
    --payload '{}' \
    --output text > /dev/null
  echo "Invocation $i started"
done

echo -e "\nWaiting for all invocations to complete..."
sleep 10

echo -e "\n=== Execution Summary ==="
aws logs filter-log-events \
  --log-group-name "$LOG_GROUP" \
  --start-time $TIMESTAMP \
  --query 'events[].message' \
  --output text | grep 'REPORT RequestId'