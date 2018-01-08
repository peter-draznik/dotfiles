set nocompatible
syntax enable
so ~/.vim/plugins.vim

"----- Global -----"
set backspace=indent,eol,start "Make backspace behave like normal editor"
let mapleader=',' "Change default leader from \\ to ,"




"----- Visuals -----"
set number "Activate linenumbers"
colorscheme atom-dark-256 
set t_CO=256 "Set Terminal colors to 256"




"----- Search -----"
set hlsearch
set incsearch




"----- Split-Management-----"
set splitbelow
set splitright




"----- Mappings -----"
"Make it easy to edit .vimrc file"
nmap <Leader>ev :tabedit $MYVIMRC<cr>
"Make it easy to edit plugins.vim file"
nmap <Leader>ep :tabedit ~/.vim/plugins.vim<cr>
"Make it easy to edit .bash_profile file"
nmap <Leader>eb :tabedit ~/.bash_profile<cr>
"Close Tab"
nmap <Leader>tc :tabclose<cr>
"Add Simple Highlight removal command"
nmap <Leader><space> :nohlsearch<cr>


"----- Sytastic -----"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0





"----- Vimux -----"
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>
" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>




"----- NERDTree -----"
"Make NERDTree easier to toggle.
nmap <D-1> :NERDTreeToggle<cr>
let NERDTreeShowHidden=1
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')





"----- Airline-----"
let g:airline#extensions#tabline#enabled = 1







"----- TagbarToggle -----"
nmap <Leader>tt :TagbarToggle<CR>






"----- The Nerd Commenter-----"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1


"----- CtrlP -----"
"nmap <c-R> :CtrlPBufTag<cr>"
"nmap <D-e> :CtrlPMRUFiles<cr>
"----- Auto-Commands -----"
"Auto-source .vimrc on save"
augroup autosourcing
	autocmd!
	autocmd BufWritePost .vimrc source %
	autocmd BufWritePost plugins.vim source $MYVIMRC
	autocmd BufWritePost plugins.vim :PluginInstall
augroup END
"NERDTree
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

