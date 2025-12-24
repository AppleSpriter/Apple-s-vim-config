-- 1. 自动下载插件管理器 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. 安装 LSP 相关插件
require("lazy").setup({
-- [核心：LSP 服务] 为了精准跳转 nn.Linear 等源码
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
-- [替代 CtrlP] Telescope: 极其强大的模糊搜索
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- [替代 NERDTree] nvim-tree: 现代文件浏览器
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- [替代 vim-airline] lualine: 极速 Lua 状态栏
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  -- [跳转] 替代 EasyMotion 的神器: flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      -- 核心快捷键：按 s 键开始瞬移
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      -- 针对树形选择（比如想选定一个函数块）
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- 在跳转中搜索
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    },
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup()
    end
  },
  -- [补全引擎] 现代补全方案
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" }, -- 代码片段引擎
}
)

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright" } -- 自动安装 Python 语言服务
})

-- 设置快捷键：gd 跳转到定义
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
-- 设置快捷键：K 显示文档说明
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})

-- ==========================================
-- 3. 基础设置
-- ==========================================
vim.g.mapleader = " "          -- 设置 Leader 键为空格
vim.opt.number = true          -- 显示行号
vim.opt.relativenumber = true  -- 相对行号
vim.opt.shiftwidth = 4         -- 缩进
vim.opt.tabstop = 4
vim.opt.expandtab = true       -- 空格替换 Tab
vim.opt.cursorline = true      -- 高亮当前行
vim.opt.termguicolors = true   -- 启用真彩色支持（重要！）

-- ==========================================
-- 4. 插件初始化设置
-- ==========================================
require("nvim-tree").setup()
require("lualine").setup({ options = { theme = 'dracula' } })
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "pyright" } })

-- ==========================================
-- 5. 快捷键映射 (按你的习惯配置)
-- ==========================================
local keymap = vim.keymap.set
local opts = { silent = true }

-- [文件树] 依然用 F3 打开/关闭
keymap('n', '<F3>', ':NvimTreeToggle<CR>', opts)
-- 设置 F4 键打开/关闭函数列表
vim.keymap.set('n', '<F4>', ':SymbolsOutline<CR>', { silent = true })

-- [Telescope] 替代 CtrlP 
-- 空格+ff 搜文件; 空格+fg 搜内容 (类似 grep)
keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
keymap('n', '<C-p>', ':Telescope find_files<CR>', opts) -- 保持 Ctrl+P 习惯

-- [LSP 定义跳转] 核心功能：看 Python 源码
keymap('n', 'gd', vim.lsp.buf.definition, opts) -- 跳转定义
keymap('n', 'K', vim.lsp.buf.hover, opts)       -- 查看函数签名/文档说明
keymap('n', 'gr', ':Telescope lsp_references<CR>', opts) -- 查看哪里引用了它

-- ==========================================
-- 6. Python LSP 配置
-- ==========================================
-- 现在的标准写法：
if vim.lsp.config then
    -- 0.11+ 的原生写法
    vim.lsp.config('pyright', {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt" },
    })
    vim.lsp.enable('pyright')
else
    -- 兼容旧版本 (Neovim < 0.11)
    require('lspconfig').pyright.setup{}
end

-- 只有在 LSP 附加到缓冲区时才定义的快捷键
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }
    -- 跳转定义
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- 悬浮显示文档 (在 nn.Linear 上按 K)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    -- 重命名变量 (非常有用的重构功能)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end,
})
