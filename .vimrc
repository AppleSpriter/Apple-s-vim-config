set nocompatible    " 去除VI一致性,必须
" =========================================基本设置============================================
" set cc=80         " 设置python PEP8 80行高亮
set number          " 设置全局行号
set relativenumber  " 设置相对行号
set expandtab       " 文件中tab替换为空格 设定 tab 长度为 4
set tabstop=4       " 既有文件识别多少个空格组合成一个tab
set shiftwidth=4    " 缩进时字符数
set softtabstop=4   " insert模式tab的空格数
set scrolloff=6     " 上下可视行数  
set wrap            " 较长的一行拆成多行显示
set cursorcolumn    " 高亮列 下面是配色 有colorscheme可能无效
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=cyan
set cursorline      " 高亮行 下面是配色 有colorscheme可能无效
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
let mapleader=' '   " vim全局<leader>设置为空格,默认为逗号
nnoremap <C-N> :bn<CR>  " 设置切换Buffer向前快捷键
nnoremap <C-M> :bp<CR>  " 设置切换Buffer向后快捷键

" set mouse=a         " 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）  
" set selection=exclusive  
" set selectmode=mouse,key 
" set statusline=%m%r%h%w\ TYPE=%Y\ ASCII=\%03.3b\ HEX=\%02.2B\ [POS=%04l,%04v][%p%%]\ LEN=%L   " 设置底端状态栏 插件覆盖
" =============================================================================================
"
" =========================================配色方案============================================
colorscheme molokai " No.1配色
set t_Co=256        " terminal color 256色显示
set background=dark " 暗色背景
" colorscheme torte     " 经典紫红
" colorscheme darkblue  " 暗色细粒度
" colorscheme murphy    " 亮色高对比度
" colorscheme zellner   " 橙黑色 可以显示高亮行列
" colorscheme solarized
" =============================================================================================

" =========================================YCM配置=============================================
let g:ycm_collect_identifiers_from_tags_files = 1           " 开启 YCM
let g:ycm_collect_identifiers_from_comments_and_strings = 1 " YCM基于标签引擎
let g:syntastic_ignore_files=[".*\.py$"]                    " 注释与字符串中的内容也用于补全
let g:ycm_seed_identifiers_with_syntax = 1                  " 语法关键字补全
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']  " 映射按键 快速向下
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']  " 映射按键 快速向上
let g:ycm_complete_in_comments = 1                          " 在注释输入中也能补全
let g:ycm_complete_in_strings = 1                           " 在字符串输入中也能补全
let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 注释和字符串中的文字也会被收入补全
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0                           " 禁用语法检查
let g:ycm_min_num_of_chars_for_completion=2                 " 从第2个键入字符就开始罗列匹配项
let g:ycm_confirm_extra_conf=0    "打开vim时不再询问是否加载ycm_extra_conf.py配置
let g:ycm_collect_identifiers_from_tag_files = 1 "使用ctags生成的tags文件
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>" |    " 回车即选中当前项
nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR>|         " 跳转到定义处
" =============================================================================================

" =========================================intentLine配置==================================
let g:indentLine_setColors = 0
let g:indentLine_color_term = 239
let g:indentLine_color_tty_light = 4 " (default: 4)
let g:indentLine_color_dark = 2 " (default: 2)
let g:indentLine_bgcolor_term = 202
let g:indentLine_bgcolor_gui = '#FF5F00'
let g:indentLine_char = '¦'
" =============================================================================================

" =========================================airline配置=========================================
let g:airline_theme="luna"          " 
let g:airline_powerline_fonts = 1   " 这个是安装字体后 必须设置此项 
" =============================================================================================

" =========================================CtrlP配置===========================================
let g:ctrlp_map = '<c-p>'           " 全局快捷键
let g:ctrlp_cmd = 'CtrlP'           " cmd下也可以用?
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:20'   " 设置ctrlp的窗口位置
" =============================================================================================

" =========================================NERDTree配置========================================
autocmd vimenter * NERDTree         " NERDTree自动启动
let NERDTreeShowBookmarks = 1       " 自动显示Bookmark,:Bookmark xxx 添加xxx书签
nmap <F10> :NERDTreeToggle <CR>     " 快捷键打开关闭nerdtree
" =============================================================================================

" =========================================Vundle插件管理配置==================================
set rtp+=~/.vim/bundle/Vundle.vim   " 设置包括vundle和初始化相关的runtime path
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'       " 让vundle管理插件版本
Plugin 'tpope/vim-fugitive'         " Vim+Git
Plugin 'L9'                         " 其他bundle可能依赖
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}                  " 用来写HTML文件的
Plugin 'Yggdroot/indentLine'        " 缩进加强显示
Plugin 'git://github.com/scrooloose/nerdtree.git'
Plugin 'git://github.com/Xuyuanp/nerdtree-git-plugin.git'   " 强大的nerdtree实现文件列表
Plugin 'Valloric/YouCompleteMe'     " YCM不解释
Plugin 'git://github.com/kien/ctrlp.vim'                    " 按ctrl+p即可实现搜索指定文件
Plugin 'bling/vim-airline'          " 底端状态栏美化
Plugin 'vim-airline/vim-airline-themes'
Plugin 'git://github.com/Lokaltog/vim-easymotion'           " 快速定位
" <leader><leader>  + w	跳转到下面的某个word
" 					+ b 跳转到上面的某个word
" 					+ f	跳转到接下来输入的char
"					+ j/k	跳转到某一行开头
Plugin 'git://github.com/yegappan/taglist.git'              " taglist查看函数名
Plugin 'git://github.com/tpope/vim-surround.git'            " 引号配对
call vundle#end()            
filetype plugin indent on    " 文件类型检测
" 以下范例用来支持不同格式的插件安装.
" 请将安装插件的命令放在vundle#begin和vundle#end之间.
" Github上的插件
" 格式为 Plugin '用户名/插件仓库名'
" 来自 http://vim-scripts.org/vim/scripts.html 的插件
" Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名'
" 只是此处的用户名可以省略
" 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
" 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
" Plugin 'file:///home/gmarik/path/to/plugin'
" 加载vim自带和插件相应的语法和文件类型相关脚本
" 忽视插件改变缩进,可以使用以下替代:
" filetype plugin on
" 
" 简要帮助文档
" :PluginList       - 列出所有已配置的插件
" :PluginInstall    - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" :PluginClean      - 清除未使用插件,需要确认; 追加 `!`
" 自动批准移除未使用插件
" 
" 查阅 :h vundle 获取更多细节和wiki以及FAQ
" 将你自己对非插件片段放在这行之后
