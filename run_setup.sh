mkdir packpath
git clone --depth 1 https://github.com/neovim/nvim-lspconfig packpath/nvim-lspconfig
git clone --depth 1 https://github.com/nvim-lua/plenary.nvim packpath/plenary.nvim

./tests/$1/setup.sh 
