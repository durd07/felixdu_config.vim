" """""""""""""""""""""""""""""" common configuration """"""""""""""""""""""""""""""""""""""""""""""
set mouse=a
set cursorline
set cc=101
set number
highlight Cursorline term=bold cterm=bold
set t_Co=256
set t_ut=
set encoding=utf-8

""" fold """
set foldmethod=syntax
set foldlevel=99

let g:mapleader=" "

if has("nvim")
	set cmdheight=0
else
	"set wildoptions=pum
	set fillchars=vert:│
endif

if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " show msg when any other cscope db added
    set cscopeverbose
endif

"""""""""""""""""""""""""""""""""""" vim-plug configuration """"""""""""""""""""""""""""""""""""""""
function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&runtimepath, trim(g:plugs[a:name].dir, "/")) >= 0)
endfunction

"""
""" Plug 'durd07/vim-monokai'
"""
if PlugLoaded("vim-monokai")
	colorscheme monokai
	let g:monokai_term_italic=1
	let g:monokai_gui_italic=1
endif

"""
""" Plug 'bronson/vim-trailing-whitespace'
"""
if PlugLoaded("vim-trailing-whitespace")
	map <leader><space> :FixWhitespace<cr>
endif

"""
""" Plug 'junegunn/fzf.vim'
"""
if PlugLoaded("fzf.vim")
	nmap <F9> :FZF <CR>
	nmap <F8> :Rg <c-r>=expand("<cword>")<cr><CR>
	let g:fzf_layout = { 'down': '~60%' }
endif

"""
""" Plug 'vim-airline/vim-airline'
"""
if PlugLoaded("vim-airline")
	map <F10> :AirlineToggle <CR>
	let g:airline_extensions = ['branch', 'tabline']
	let g:airline#extensions#tabline#enabled=1
	let g:airline#extensions#tabline#buffer_nr_show=1

	let g:airline#existsions#whitespace#enabled=0
	let g:airline#existsions#whitespace#symbol="!"
	let g:airline#extensions#whitespace#show_message=0
	let g:airline_detect_modified=1

	if !exists('g:airline_symbols')
	  let g:airline_symbols={}
	endif
	"let g:airline#extensions#tabline#fnamemod = ':p:.'
	let g:airline#extensions#tabline#fnamemod=':t:.'
	"let g:airline_left_sep=''
	"let g:airline_left_alt_sep=''
	"let g:airline_right_sep=''
	"let g:airline_right_alt_sep=''
	"let g:airline_symbols.branch=''
	"let g:airline_symbols.readonly=''
	"let g:airline_symbols.linenr='☰'
	"let g:airline_symbols.maxlinenr=''
	"let g:airline_symbols.maxlinenr=''

	function! s:update_git_status()
	  let g:airline_section_b = "%{get(g:,'coc_git_status','')}"
	endfunction

	let g:airline_section_b = "%{get(g:,'coc_git_status','')}"

	autocmd User CocGitStatusChange call s:update_git_status()
endif

""" Plug 'ludovicchabant/vim-gutentags'
if PlugLoaded("vim-gutentags")
	let g:gutentags_add_default_project_roots = 0
	let g:gutentags_project_root = ['.project']
	let g:gutentags_ctags_tagfile = '.tags'  "所生成的数据文件的名称
	let g:gutentags_modules = []
	if executable('gtags-cscope') && executable('gtags')
		let g:gutentags_modules += ['gtags_cscope']
	endif
	"if executable('ctags')
	"	let g:gutentags_modules += ['ctags']
	"endif
	let s:vim_tags = expand('~/.cache/tags')  "将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
	let g:gutentags_cache_dir = s:vim_tags
	let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q', '--c++-kinds=+px', '--c-kinds=+px']  "配置 ctags 的参数
	let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']  "如果使用 universal ctags 需要增加
	let g:gutentags_auto_add_gtags_cscope = 1  "gutentags 自动加载 gtags 数据库的行为
	if !isdirectory(s:vim_tags)
	   silent! call mkdir(s:vim_tags, 'p')
	endif
	"let $GTAGSLABEL = 'native-pygments'
	"let $GTAGSCONF = '/home/felixdu/.gtags.conf'
	let g:gutentags_define_advanced_commands = 1
	let g:gutentags_trace = 0
endif

if PlugLoaded("quickr-cscope.vim")
    let g:quickr_cscope_use_qf_g = 1
    let g:quickr_cscope_autoload_db = 0
    let g:quickr_cscope_program = "gtags-cscope"
    let g:quickr_preview_on_cursor = 1
    let g:quickr_preview_exit_on_enter = 1
    let g:quickr_preview_line_hl = "Search"
    "let g:quickr_cscope_db_file = "GTAGS"
endif

"""
""" Plug 'preservim/tagbar'
"""
if PlugLoaded("tagbar")
	nmap tb :TagbarToggle<CR>
endif

"""
""" Plug 'neoclide/coc.nvim', {'branch': 'release'}
"""
if PlugLoaded("coc.nvim")
	" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
	" utf-8 byte sequence
	set encoding=utf-8
	" Some servers have issues with backup files, see #649
	set nobackup
	set nowritebackup

	" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
	" delays and poor user experience
	set updatetime=300

	" Always show the signcolumn, otherwise it would shift the text each time
	" diagnostics appear/become resolved
	" set signcolumn=yes

	" Use tab for trigger completion with characters ahead and navigate
	" NOTE: There's always complete item selected by default, you may want to enable
	" no select by `"suggest.noselect": true` in your configuration file
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config
	"inoremap <silent><expr> <TAB>
	"      \ coc#pum#visible() ? coc#pum#next(1) :
	"      \ CheckBackspace() ? "\<Tab>" :
	"      \ coc#refresh()
	"inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	function! CheckBackspace() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion
	if has('nvim')
	  inoremap <silent><expr> <c-space> coc#refresh()
	else
	  inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use K to show documentation in preview window
	nnoremap <silent> K :call ShowDocumentation()<CR>

	function! ShowDocumentation()
	  if CocAction('hasProvider', 'hover')
	    call CocActionAsync('doHover')
	  else
	    call feedkeys('K', 'in')
	  endif
	endfunction

	" Highlight the symbol and its references when holding the cursor
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	augroup mygroup
	  autocmd!
	  " Setup formatexpr specified filetype(s)
	  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	  " Update signature help on jump placeholder
	  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Applying code actions to the selected code block
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying code actions at the cursor position
	nmap <leader>ac  <Plug>(coc-codeaction-cursor)
	" Remap keys for apply code actions affect whole buffer
	nmap <leader>as  <Plug>(coc-codeaction-source)
	" Apply the most preferred quickfix action to fix diagnostic on the current line
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Remap keys for applying refactor code actions
	nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
	xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
	nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

	" Run the Code Lens action on the current line
	nmap <leader>cl  <Plug>(coc-codelens-action)

	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Remap <C-f> and <C-b> to scroll float windows/popups
	if has('nvim-0.4.0') || has('patch-8.2.0750')
	  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges
	" Requires 'textDocument/selectionRange' support of language server
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer
	command! -nargs=0 Format :call CocActionAsync('format')

	" Add `:Fold` command to fold current buffer
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer
	command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

	" Add (Neo)Vim's native statusline support
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline
	set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	" Mappings for CoCList
	" Show all diagnostics
	nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions
	nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
	" Show commands
	nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
	nnoremap <silent><nowait> <leader>b  :<C-u>CocCommand document.showIncomingCalls<cr>
	" Find symbol of current document
	nnoremap <silent><nowait> <leader>o  :call ToggleOutline()<CR>
	function! ToggleOutline() abort
	  let winid = coc#window#find('cocViewId', 'OUTLINE')
	  if winid == -1
	    call CocActionAsync('showOutline', 1)
	  else
	    call coc#window#close(winid)
	  endif
	endfunction
	" Search workspace symbols
	nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
	nnoremap <silent><nowait> <leader>ss :exe 'CocList -I --input='.expand('<cword>').' symbols'<cr>
	nnoremap <silent><nowait> <leader>w  :exe 'CocList -I --input='.expand('<cword>').' words'<cr>
	" Do default action for next item
	nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
	" Do default action for previous item
	nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
	" Resume latest coc list
	nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>

	map <F3> :CocCommand explorer<CR>
	map <F4> :CocDiagnostics <CR>

	"hi CocSearch ctermfg=12 guifg=#18A3FF
	"hi CocMenuSel ctermbg=240 guibg=#13354A
	"hi CocErrorSign ctermfg=197

	"autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']
endif

"""""""""""""""""""""""""""""""""""" other useful scripts """"""""""""""""""""""""""""""""""""""""""

""" use <leader><num> to jump to buffer
function! BufPos_Initialize()
    exe "map <leader>0 :buffer 0<CR>"
    let l:count=1
    for i in range(1, 9)
        exe "map <leader>" . i . " :buffer " . i . "<CR>"
    endfor
endfunction
au VimEnter * call BufPos_Initialize()

""" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <Leader>t :ZoomToggle<CR>

""" RUN
let g:asyncrun_open=10
map <F5> :call Run()<CR>
func! Run()
    exec "w"
    if &filetype == 'c'
        exec "AsyncRun gcc -g % -o %< -std=c11 && ./%<"
    elseif &filetype == 'python'
	exec "AsyncRun -raw=1 python3 %"
    elseif &filetype == 'cpp'
        exec "AsyncRun g++ -g % -o %< -std=c++20 && ./%<"
    elseif &filetype == 'go'
        exec "AsyncRun -raw=1 go run %"
    elseif &filetype == 'java'
        exec "AsyncRun javac %"
    elseif &filetype == 'sh'
        exec "AsyncRun -raw=1 chmod +x ./% && ./%"
    endif
endfunc

""" Run Block
map <F6> :call RunBlock()<CR>
function! RunBlock()
    let startline = search('```', 'b')
    let endline = search('```')
    let content = getline(startline+1, endline-1)

    let ft = matchstr(getline(startline), '```\s*\zs[0-9A-Za-z_+-]*')
    if !empty(ft) && ft !~ '^\d*$'
        if ft == 'c'
            call writefile(content, '/tmp/vim-cb'.'.c')
            exec "AsyncRun -raw gcc -g /tmp/vim-cb.c -o /tmp/vim-cb.bin && /tmp/vim-cb.bin"
        elseif ft == 'python'
            call writefile(content, '/tmp/vim-cb'.'.py')
            exec "AsyncRun -mode=term -pos=bottom -raw python3 /tmp/vim-cb.py"
        elseif ft == 'c++'
            call writefile(content, '/tmp/vim-cb'.'.cpp')
            exec "AsyncRun -raw g++ -g /tmp/vim-cb.cpp -o /tmp/vim-cb.bin && /tmp/vim-cb.bin"
        elseif ft == 'go'
            call writefile(content, '/tmp/vim-cb'.'.go')
            exec "AsyncRun -raw go run /tmp/vim-cb.go"
        elseif ft == 'java'
            call writefile(content, '/tmp/vim-cb'.'.java')
            exec "AsyncRun -raw javac /tmp/vim-cb.java"
        elseif ft == 'sh'
            call writefile(content, '/tmp/vim-cb'.'.sh')
            "exec "AsyncRun -raw=1 chmod +x /tmp/vim-cb.sh && /tmp/vim-cb.sh"
            exec "AsyncRun -mode=term -pos=bottom -raw=1 chmod +x /tmp/vim-cb.sh && /tmp/vim-cb.sh"
	else
            echo ft
        endif
    endif
endfunction

"""""""""""""""""""""""""""""""""""" work arounds """"""""""""""""""""""""""""""""""""""""""""""""""
" enable mouse for vim in tmux
if !has('nvim')
  set ttymouse=xterm2
else
  " for solve the problem nvim in tmux act slow
  set timeoutlen=1000 ttimeoutlen=0
endif

"""""""""""""""""""""""""""""""""""" temp configuration """"""""""""""""""""""""""""""""""""""""""""
autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
"autocmd FileType markdown setlocal tabstop=8 softtabstop=8 shiftwidth=8 expandtab
"autocmd BufRead,BufNewFile /home/felixdu/src/service-mesh/envoy/* setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" OSCYank
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" https://github.com/ojroques/vim-oscyank#the-plugin-does-not-work-with-tmux
let g:oscyank_term = 'default'

let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-explorer', 'coc-clangd', 'coc-pyright', 'coc-go']

" disable line number for Terminal
if has("nvim")
	autocmd TermOpen * setlocal nonumber norelativenumber
	" Enable indent-black-line
	autocmd VimEnter * IBLEnable
else
	autocmd TerminalOpen * setlocal nonumber norelativenumber
endif

