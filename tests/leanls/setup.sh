set -e 

# set up lean language server
curl https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh -sSf | sh -s -- --default-toolchain "leanprover/lean4:nightly-2021-07-09" -y
echo "$HOME/.elan/bin/" >> $GITHUB_PATH
PATH="$PATH:$HOME/.elan/bin/"

# pre-build fixtures
( cd fixtures/example-project-1 && leanpkg configure && leanpkg build; )

# pre-build fixtures
( cd fixtures/example-project-2 && leanpkg configure && leanpkg build; )
