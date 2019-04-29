"personal setting 
set nu!
syntax enable
syntax on
colorscheme evening
set autoindent
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set go=
set hlsearch
"set guifont=Monospace\ 12
"set guifont=Courier\ 10\ Pitch\ 12
set guifont=DejaVu\ Sans\ Mono\ 12
set lines=40 columns=80
set guioptions+=r
filetype plugin on
set nocompatible

"show whitespace
highlight ExtraWhitespace ctermbg=Grey guibg=DarkGrey
autocmd BufWinEnter * match ExtraWhitespace /^\t\+\|\t\+$/

"fix backspace
set backspace=indent,eol,start

"encoding
set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
if has("win32")
    set fileencoding=chinese
else
    set fileencoding=utf-8
endif

"vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'delimitMate.vim'
Plugin 'lrvick/Conque-Shell'
Plugin 'rhysd/vim-clang-format'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'taglist.vim'
Plugin 'winmanager'
Plugin 'vim-scripts/BOOKMARKS--Mark-and-Highlight-Full-Lines'
Plugin 'fortran.vim'
Plugin 'tpope/vim-fugitive'
"Plugin 'Shougo/vimproc.vim'
"Plugin 'Shougo/vimshell.vim'
"Plugin 'Shougo/unite.vim'
"Plugin 'vim-latex/vim-latex'

call vundle#end()

"YouCompleteMe
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
let g:ycm_seed_identifiers_with_syntax=1
set completeopt-=preview
set completeopt=longest,menu
let g:ycm_cache_omnifunc=0
let g:ycm_min_num_of_chars_for_completion=1
let g:ycm_error_symbol='>>'
let g:ycm_warning_symbol='>*'
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
map <F9> :YcmDiags<CR>
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
"let g:ycm_semantic_triggers = {
"    \  'tex'  : ['{']
"\ }


"ctags
map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
set tags=tags

"taglist
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1

"NERDTree
let g:winManagerWindowLayout='NERDTree|TagList'
nmap <silent> wm :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR>
let g:NERDTree_title = "[NERDTree]"

function! NERDTree_Start()
    exe 'NERDTree'
endfunction 

function! NERDTree_IsValid()  
    return 1
endfunction

"cscope
nmap <C-ESC>s :cs find s <C-R>=expand("<cword>")<CR><CR> 
nmap <C-ESC>g :cs find g <C-R>=expand("<cword>")<CR><CR> 
nmap <C-ESC>c :cs find c <C-R>=expand("<cword>")<CR><CR> 
nmap <C-ESC>t :cs find t <C-R>=expand("<cword>")<CR><CR> 
nmap <C-ESC>e :cs find e <C-R>=expand("<cword>")<CR><CR> 
nmap <C-ESC>f :cs find f <C-R>=expand("<cfile>")<CR><CR> 
nmap <C-ESC>i :cs find i ^<C-R>=expand("<cfile>")<CR><CR>
nmap <C-ESC>d :cs find d <C-R>=expand("<cword>")<CR><CR> 
set cscopequickfix=s-,c-,d-,i-,t-,e-
map <F10> :call Do_Cs()<CR>

function Do_Cs()
    cd ~/.tags
    silent !find %:p:h -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.cpp" > cscope.files
    silent !cscope -bRq -i cscope.files
    cs add cscope.out
    cd %:p:h
    "silent! execute "!cscope -bRq"
    "execute "cs add cscope.out"
endf

"google chrome"
nmap <C-ESC>h :call Do_Browser()<CR>

function Do_Browser()
    silent! execute "!google-chrome %"
endf

"comment&&uncomment
vnoremap <C-c> :call Do_Comment()<CR>

function! Do_Comment()
    let line=getline('.')
    if match(line, '^\s*//') == 0
        s/^\(\s*\)\/\//\1/g
    else
        s/^\(\s*\)/\1\/\//g
    endif
endf

"vim-latex
"set grepprg=grep\ -nH\ $*
"let g:tex_flavor='latex'

"fortran
let fortran_free_source=1
let fortran_more_precise=1
