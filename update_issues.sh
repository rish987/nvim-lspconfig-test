cd ./tests/$1
issue_title="$1 failure"
if curl --fail https://api.github.com/repos/rish987/nvim-lspconfig-test/issues?state=open | jq "map(select(.title == \"$issue_title\"))" | jq '.[0]' -e | jq '.number' -e &> .number
then
  number=$(cat .number)
  if test -f ".fail"
  then
    echo "Existing issue found: \#$number."
    echo "Tests failed; see \"Run tests\" step for more information."
    exit 1
  else
    echo "Test passed; closing issue \#$number..."
    curl --request PATCH \
    --url https://api.github.com/repos/rish987/nvim-lspconfig-test/issues/$number \
    --header "authorization: Bearer $2" \
    --header 'content-type: application/json' \
    --data "{ \
      \"state\": \"closed\"\
      }" \
    --fail
    exit 0
  fi
else
  if test -f ".fail"
  then
    curl --request POST \
    --url https://api.github.com/repos/rish987/nvim-lspconfig-test/issues \
    --header "authorization: Bearer $2" \
    --header 'content-type: application/json' \
    --data "{ \
      \"title\": \"$issue_title\",\
      \"body\": \"$(cat issue_body)\"\
      }" \
    --fail &> /dev/null
    echo "Tests failed; see \"Run tests\" step for more information."
    exit 1
  else
    exit 0
  fi
fi
