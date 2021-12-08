vim.o.display = "lastline" -- Avoid neovim/neovim#11362
vim.o.directory = ""

local __file__ = debug.getinfo(1).source:match("@(.*)$")
local root_dir = vim.fn.fnamemodify(__file__, ":p:h")
local packpath = root_dir .. "/packpath/*"
vim.opt.runtimepath:append(packpath):append(root_dir .. "/nvim-lspconfig-test")

vim.cmd([[
  runtime! plugin/lspconfig.vim
  runtime! plugin/plenary.vim
]])
