vim.o.display = "lastline" -- Avoid neovim/neovim#11362
vim.o.directory = ""

local __file__ = debug.getinfo(1).source:match("@(.*)$")
local root_dir = vim.fn.fnamemodify(__file__, ":p:h")
vim.opt.runtimepath:append(root_dir)

local packpath = root_dir .. "/packpath"
vim.opt.packpath = packpath
vim.cmd("packloadall")
