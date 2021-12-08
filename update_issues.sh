#!/usr/bin/env bash

set -euo pipefail

server=$1
os=$2
key=$3
repo=$GITHUB_REPOSITORY
workflow=$GITHUB_RUN_ID
commit=$GITHUB_SHA
trigger=$GITHUB_EVENT_NAME

cd ./tests/$server

fail_msg="Tests failed; see \"Run tests\" step for more information."

issue_title="\`$server\` failure on \`$os\`"

curl -sS --fail --header "authorization: Bearer $key" $GITHUB_API_URL/repos/$repo/issues?state=open > .issues

test -s .issues

# existing issue
if cat .issues | jq "map(select(.title == \"$issue_title\"))" | jq '.[0]' -e | jq '.number' -e > .number
then
  number=$(cat .number)
  if test -f ".fail"
  then
    # ignore existing errors in PRs
    if [ "$trigger" = "pull_request" ]; then echo "$fail_msg Ignoring existing issue #$number for this PR..."; exit 0; fi
    echo "Existing issue found: #$number."
    echo "$fail_msg"
    exit 1
  else
    if [ "$trigger" = "pull_request" ]; then echo "Fix implemented; not closing issue #$number for a PR (will be closed on merge)..."; exit 0; fi
    echo "Test passed; closing issue #$number..."
    curl --request POST \
    --url $GITHUB_API_URL/repos/$repo/issues/$number/comments \
    --header "authorization: Bearer $key" \
    --header 'content-type: application/json' \
    --data "{ \
      \"body\": \"Resolved @ $commit; see workflow [$workflow]($GITHUB_SERVER_URL/$repo/actions/runs/$workflow)\"\
      }" \
    --fail &> /dev/null
    curl --request PATCH \
    --url $GITHUB_API_URL/repos/$repo/issues/$number \
    --header "authorization: Bearer $key" \
    --header 'content-type: application/json' \
    --data "{ \
      \"state\": \"closed\"\
      }" \
    --fail &> /dev/null
    exit 0
  fi
fi

# no existing issue
if test -f ".fail"
then
  # do not allow PRs to introduce failures
  if [ "$trigger" = "pull_request" ]; then echo "$fail_msg Not creating new issue for a PR..."; exit 1; fi
  curl --request POST \
  --url https://api.github.com/repos/$repo/issues \
  --header "authorization: Bearer $key" \
  --header 'content-type: application/json' \
  --data "{ \
    \"title\": \"$issue_title\",\
    \"body\": \"\`$server\` failure on \`$os\` @ $commit; see workflow [$workflow](https://github.com/$repo/actions/runs/$workflow) \n\n $(cat issue_body)\"\
    }" \
  --fail &> /dev/null
  echo "$fail_msg"
  exit 1
else
  exit 0
fi
