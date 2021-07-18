./tests/$1/setup.sh 
mkdir tests/$1/packpath
git clone --depth 1 https://github.com/neovim/nvim-lspconfig tests/$1/packpath/nvim-lspconfig
git clone --depth 1 https://github.com/nvim-lua/plenary.nvim tests/$1/packpath/plenary.nvim
