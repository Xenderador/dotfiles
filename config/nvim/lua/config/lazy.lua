local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    vim.cmd("let g:netrw_liststyle = 3")

    local opt = vim.opt

    opt.relativenumber = true
    opt.number = true

    -- tabs & indentation
    opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
    opt.shiftwidth = 2 -- 2 spaces for indent width
    opt.expandtab = true -- expand tab to spaces
    opt.autoindent = true -- copy indent from current line when starting new one

    opt.wrap = false

    -- search settings
    opt.ignorecase = true -- ignore case when searching
    opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

    opt.cursorline = true

    -- turn on termguicolors for tokyonight colorscheme to work
    -- (have to use iterm2 or any other true color terminal)
    opt.termguicolors = true
    opt.background = "dark" -- colorschemes that can be light or dark will be made dark
    opt.signcolumn = "yes" -- show sign column so that text doesn't shift

    -- backspace
    opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

    -- clipboard
    opt.clipboard:append("unnamedplus") -- use system clipboard as default register

    -- split windows
    opt.splitright = true -- split vertical window to the right
    opt.splitbelow = true -- split horizontal window to the bottom

    -- turn off swapfile
    opt.swapfile = false
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
