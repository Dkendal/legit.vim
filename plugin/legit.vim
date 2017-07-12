if exists('g:loaded_legit_vim')
    finish
endif

let g:loaded_legit_vim = 1

if !has('nvim')
  echoerr 'legit.vim requires NeoVim.'
  finish
endif

let g:legit_vim_git_format="%C(yellow)%h %C(reset)%s %C(blue)[%an] %C(red)%d%C(reset)%n"

function! s:getsha() abort
  " let shapattern = '^\w\+\s'
  " let match = matchstr(a:str, shapattern)
  " let result = matchstr(getline('.'), '^\x\+\>')
  let result = matchstr(getline('.'), '^\x\+')

  return result[0]
endfunction

function! s:format() abort
  return g:legit_vim_git_format
endfunction

function! legit#peek() abort
  let sha = s:getsha()
  let git_command =
        \ [ 'echo', 'git'
        \ , 'show'
        \ , '--'
        \ , sha
        \ ]
  vnew
  call termopen(git_command)
  startinsert
endfunction

command! LegitPeek :call legit#peek()

function! legit#log_minor_mode() abort
  set readonly
  nnoremap <buffer> q :close<CR>
  nnoremap <buffer> <esc> :close<CR>
  nnoremap <buffer> <localleader> <tab> :LegitPeek
endfunction

function! legit#log() abort
  let git_command =
        \ [ 'git'
        \ , 'log'
        \ , '--format='.s:format()
        \ ]
  vnew
  call termopen(git_command)
  call legit#log_minor_mode()
  " startinskrt
endfunction

command! LegitLog :call legit#log()
