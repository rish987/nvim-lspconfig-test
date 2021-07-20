set -e 

# set up lean language server
if ! which elan > /dev/null; then
  curl https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh -sSf | sh -s -- --default-toolchain "leanprover/lean4:nightly-2021-07-09" -y
  if [ ! -z ${GITHUB_PATH+x} ]; then 
    echo "$HOME/.elan/bin/" >> $GITHUB_PATH; 
  else
    echo 'PATH="$HOME/.elan/bin:$PATH"' >> $HOME/.profile
  fi
  PATH="$HOME/.elan/bin/:$PATH"
fi

# pre-build fixtures
( cd fixtures/example-project-1 && leanpkg configure && leanpkg build; )

# pre-build fixtures
( cd fixtures/example-project-2 && leanpkg configure && leanpkg build; )
