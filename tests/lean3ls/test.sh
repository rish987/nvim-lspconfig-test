#!/usr/bin/env bash

set -euo pipefail

nvim --headless --noplugin -u "$NVIM_TEST_PATH/minimal_init.lua" -c "PlenaryBustedDirectory tests/ { minimal_init = '$NVIM_TEST_PATH/minimal_init.lua' }"
