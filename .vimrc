set nocompatible              " 去除VI一致性,必须
filetype off                  " 必须

" 设置包括vundle和初始化相关的runtime path
set rtp+=~/.vim/bundle/Vundle.vim
set number
" 设定 tab 长度为 4
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" 上下可视行数  
set scrolloff=6  
" 高亮行列
set cursorcolumn
set cursorline
" colorscheme molokai
colorscheme torte
" set background=dark
" colorscheme solarized
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）  
" set mouse=a  
" set selection=exclusive  
" set selectmode=mouse,key 
"
" vim全局<leader>设置为空格,默认为逗号
let mapleader=' '
" 设置底端状态栏
set statusline=%m%r%h%w\ TYPE=%Y\ ASCII=\%03.3b\ HEX=\%02.2B\ [POS=%04l,%04v][%p%%]\ LEN=%L
let g:molokai_original = 1
" let g:rehash256 = 1
" let g:ycm_server_python_interpreter='/usr/bin/python' "指定python编译器
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'  "配置默认的ycm_extra_conf.py

" 配置ycm
let g:ycm_collect_identifiers_from_tags_files = 1           " 开启 YCM
" 基于标签引擎
let g:ycm_collect_identifiers_from_comments_and_strings = 1 "
" 注释与字符串中的内容也用于补全
let g:syntastic_ignore_files=[".*\.py$"]
let g:ycm_seed_identifiers_with_syntax = 1                  " 语法关键字补全
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']  " 映射按键,
" 没有这个会拦截掉tab, 导致其他插件的tab不能用.
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
let g:ycm_complete_in_comments = 1                          "
" 在注释输入中也能补全
let g:ycm_complete_in_strings = 1                           "
" 在字符串输入中也能补全
let g:ycm_collect_identifiers_from_comments_and_strings = 1 "
" 注释和字符串中的文字也会被收入补全
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0                           " 禁用语法检查
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>" |            "
" 回车即选中当前项
nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR>|     "
" 跳转到定义处
let g:ycm_min_num_of_chars_for_completion=2                 "
" 从第2个键入字符就开始罗列匹配项


" 配置intentLine
let g:indentLine_setColors = 0
let g:indentLine_color_term = 239
" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)
" Background (Vim, GVim)
let g:indentLine_bgcolor_term = 202
let g:indentLine_bgcolor_gui = '#FF5F00'
let g:indentLine_char = '¦'


" 配置airline
let g:airline_theme="luna" 

""这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   
" 
""打开tabline功能,方便查看Buffer和切换，这个功能比较不错"
""我还省去了minibufexpl插件，因为我习惯在1个Tab下用多个buffer"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"
""设置切换Buffer快捷键"
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>
"
"" 关闭状态显示空白符号计数,这个对我用处不大"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'
"

"自动启动NERDTree
autocmd vimenter * NERDTree
"按,jd 会跳转到定义
let g:ycm_confirm_extra_conf=0    "打开vim时不再询问是否加载ycm_extra_conf.py配置
let g:ycm_collect_identifiers_from_tag_files = 1 "使用ctags生成的tags文件

call vundle#begin()
" " 另一种选择, 指定一个vundle安装插件的路径
" "call vundle#begin('~/some/path/here')
"
" " 让vundle管理插件版本,必须
Plugin 'VundleVim/Vundle.vim'
"
" " 以下范例用来支持不同格式的插件安装.
" " 请将安装插件的命令放在vundle#begin和vundle#end之间.
" " Github上的插件
" " 格式为 Plugin '用户名/插件仓库名'
Plugin 'tpope/vim-fugitive'
" " 来自 http://vim-scripts.org/vim/scripts.html 的插件
" " Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名'
" 只是此处的用户名可以省略
Plugin 'L9'
" " 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
Plugin 'git://git.wincent.com/command-t.git'
" " 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
" Plugin 'file:///home/gmarik/path/to/plugin'

" " 插件在仓库的子目录中.
" " 正确指定路径用以设置runtimepath. 以下范例插件在sparkup/vim目录下
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " 安装L9，如果已经安装过这个插件，可利用以下格式避免命名冲突
" Plugin 'ascenator/L9', {'name': 'newL9'}
"
" Plugin 'majutsushi/tagbar'
" 缩进加强显示
Plugin 'Yggdroot/indentLine'
" 强大的nerdtree实现文件列表
Plugin 'git://github.com/scrooloose/nerdtree.git'
Plugin 'git://github.com/Xuyuanp/nerdtree-git-plugin.git'
" YCM不解释
Plugin 'Valloric/YouCompleteMe'
" 按ctrl+p即可实现搜索指定文件
Plugin 'git://github.com/kien/ctrlp.vim'
" 底端状态栏美化
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" 快速定位插件
" <leader><leader>  + w	跳转到下面的某个word
" 					+ b 跳转到上面的某个word
" 					+ f	跳转到接下来输入的char
"					+ j/k	跳转到某一行开头
Plugin 'git://github.com/Lokaltog/vim-easymotion'
" 引号配对
Plugin 'git://github.com/tpope/vim-surround.git'
"设置ctrlp的快捷方式 ctrp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
"设置ctrlp的窗口位置
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:20'

" " 你的所有插件需要在下面这行之前
call vundle#end()            " 必须
filetype plugin indent on    " 必须
" 加载vim自带和插件相应的语法和文件类型相关脚本
" " 忽视插件改变缩进,可以使用以下替代:
" "filetype plugin on
" "
" " 简要帮助文档
" " :PluginList       - 列出所有已配置的插件
" " :PluginInstall    - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" " :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" " :PluginClean      - 清除未使用插件,需要确认; 追加 `!`
" 自动批准移除未使用插件
" "
" " 查阅 :h vundle 获取更多细节和wiki以及FAQ
" " 将你自己对非插件片段放在这行之后

