#!/bin/bash

# Define the path to the coverage report file and the coverage limit
COVERAGE_FILE=$1
COVERAGE_LIMIT="90"

# Check if the coverage file exists
if [ ! -f "$COVERAGE_FILE" ]; then
  echo "Error: The coverage file '$COVERAGE_FILE' does not exist."
  exit 1
fi

# Use jq to extract the global percentage of statements coverage directly from the summary.
# The `cut -d.` command ensures we only use the integer part for comparison.
COVERAGE_VALUE=$(jq '.summary.statements.pct' "$COVERAGE_FILE" | xargs printf "%.0f")

# Check the value and compare it to the defined limit
if [ $(echo "$COVERAGE_VALUE > $COVERAGE_LIMIT" | bc) -eq 1 ]; then
  echo "✅ Success: The global code coverage is $COVERAGE_VALUE%."
  exit 0
else
  echo "❌ Failure: The global code coverage is $COVERAGE_VALUE% (the limit is $COVERAGE_LIMIT%)."
  exit 1
fi


