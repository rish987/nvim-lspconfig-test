.PHONY: setup test

check_test_var = if [ -z ${TEST} ]; then echo "must specify \$$TEST"; exit 1; fi

packpath: 
	mkdir packpath
	git clone --depth 1 https://github.com/neovim/nvim-lspconfig packpath/nvim-lspconfig
	git clone --depth 1 https://github.com/nvim-lua/plenary.nvim packpath/plenary.nvim

setup: packpath
	@${check_test_var}
	cd ./tests/${TEST} && ./setup.sh 

test: packpath
	@${check_test_var}
	( export NVIM_TEST_PATH=$(realpath .); cd ./tests/${TEST} && ( if ! ./test.sh; then touch .fail; exit 1; fi ); )
