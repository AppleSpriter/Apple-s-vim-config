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
    {
        "karb94/neoscroll.nvim",
        config = function()
            require('neoscroll').setup({
                mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
                hide_cursor = true,          -- 滚动时隐藏光标
                stop_eof = true,             -- 滚动到文件末尾停止
                respect_scrolloff = false,   -- 保持光标相对位置
                cursor_scrolls_alone = true, -- 即使到达边界光标也移动
            })
        end
    },

    -- [跳转] 替代 EasyMotion 的神器: flash.nvim
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        keys = {
            -- 核心快捷键：按 s 键开始瞬移
            { "<leader><leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            -- 针对树形选择（比如想选定一个函数块）
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            -- 在跳转中搜索
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        },
    },
    {
        'stevearc/aerial.nvim',
        opts = {},
        -- 依赖：需要 treesitter 来解析函数
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require('aerial').setup({
                -- 自动关闭（当跳转到函数后自动关闭侧边栏）
                close_on_select = false, 
                -- 布局设置
                layout = {
                    min_width = 30,
                    default_direction = "right",
                },
            })
        end
    },
    -- [补全引擎] 现代补全方案
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" }, -- 代码片段引擎
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = "sh -c 'cd app && sh ./install.sh'",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        keys = {
            { "<F5>", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },
}
)

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "pyright" } -- 自动安装 Python 语言服务
})

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
vim.keymap.set('n', '<F4>', '<cmd>AerialToggle!<CR>', { silent = true })

-- [Telescope] 替代 CtrlP 
-- 空格+ff 搜文件; 空格+fg 搜内容 (类似 grep)
keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
keymap('n', '<C-p>', ':Telescope find_files<CR>', opts) -- 保持 Ctrl+P 习惯

-- [LSP 定义跳转] 核心功能：看 Python 源码
-- -- 针对新版本优化的跳转
vim.keymap.set('n', 'gd', function()
    if vim.lsp.definition then
        vim.lsp.definition()
    else
        vim.lsp.buf.definition() -- 兼容旧版本
    end
end, opts)
vim.keymap.set('n', 'K', function()
    if vim.lsp.definition then
        vim.lsp.hover()
    else
        vim.lsp.buf.hover() -- 兼容旧版本
    end
end, opts)-- 查看函数签名/文档说明

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
