cd ./tests/$1

fail_msg="Tests failed; see \"Run tests\" step for more information."

issue_title="\`$1\` failure"
if curl --fail https://api.github.com/repos/$3/issues?state=open | jq "map(select(.title == \"$issue_title\"))" | jq '.[0]' -e | jq '.number' -e &> .number
then
  number=$(cat .number)
  if test -f ".fail"
  then
    # ignore existing errors in PRs
    if [ "$6" = "pull_request" ]; then echo "$fail_msg Ignoring existing issue #$number for this PR..."; exit 0; fi
    echo "Existing issue found: #$number."
    echo "$fail_msg"
    exit 1
  else
    if [ "$6" = "pull_request" ]; then echo "Fix implemented; not closing issue #$number for a PR (will be closed on merge)..."; exit 0; fi
    echo "Test passed; closing issue #$number..."
    curl --request POST \
    --url https://api.github.com/repos/$3/issues/$number/comments \
    --header "authorization: Bearer $2" \
    --header 'content-type: application/json' \
    --data "{ \
      \"body\": \"Resolved @ $5; see workflow [$4](https://github.com/$3/actions/runs/$4)\"\
      }" \
    --fail &> /dev/null
    curl --request PATCH \
    --url https://api.github.com/repos/$3/issues/$number \
    --header "authorization: Bearer $2" \
    --header 'content-type: application/json' \
    --data "{ \
      \"state\": \"closed\"\
      }" \
    --fail &. /dev/null
    exit 0
  fi
else
  if test -f ".fail"
  then
    # do not allow PRs to introduce failures
    if [ "$6" = "pull_request" ]; then echo "$fail_msg Not creating new issue for a PR..."; exit 1; fi
    curl --request POST \
    --url https://api.github.com/repos/$3/issues \
    --header "authorization: Bearer $2" \
    --header 'content-type: application/json' \
    --data "{ \
      \"title\": \"$issue_title\",\
      \"body\": \"\`$1\` failure @ $5; see workflow [$4](https://github.com/$3/actions/runs/$4) \n\n $(cat issue_body)\"\
      }" \
    --fail &> /dev/null
    echo "$fail_msg"
    exit 1
  else
    exit 0
  fi
fi
