set -e

nvim --headless --noplugin -u $NVIM_TEST_PATH/minimal_init.lua -c "PlenaryBustedDirectory tests/ { minimal_init = '$NVIM_TEST_PATH/minimal_init.lua' }"

false
if [ $RUNNER_OS = "macOS" ]; then false; fi
