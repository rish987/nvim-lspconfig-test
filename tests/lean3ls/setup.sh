set -e 

LEAN_VERSION="leanprover/lean4:nightly-2021-07-09"

# set up lean language server
if [ $RUNNER_OS = "Linux" ]; then
  curl https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh -sSf | sh -s -- --default-toolchain "$LEAN_VERSION" -y
elif [ $RUNNER_OS = "macOS" ]; then
  brew install elan
  elan toolchain install "$LEAN_VERSION"
  elan default "$LEAN_VERSION"
fi
sudo npm install -g lean-language-server

echo "$HOME/.elan/bin/" >> $GITHUB_PATH; 
PATH="$HOME/.elan/bin/:$PATH"

# pre-build fixtures
( cd fixtures/example-project-1 && leanpkg configure && leanpkg build; )

# pre-build fixtures
( cd fixtures/example-project-2 && leanpkg configure && leanpkg build; )
