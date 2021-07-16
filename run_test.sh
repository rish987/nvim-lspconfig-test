cd tests/$1
if ./test.sh 
then
  echo "Test succeeded."
else
  echo "Test failed."
  touch .fail
  exit 1
fi
