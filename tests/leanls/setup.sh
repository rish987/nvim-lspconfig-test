# set up lean language server
curl https://raw.githubusercontent.com/Kha/elan/master/elan-init.sh -sSf | sh -s -- --default-toolchain "leanprover/lean4:nightly-2021-07-09" -y
echo "$HOME/.elan/bin/" >> $GITHUB_PATH
