" gogh.vim - gogh (GO GitHub project manager) for vim
" Maintainer:   kyoh86
" License:      This file is placed in the public domain.

if exists('g:autoloaded_gogh_ui')
  finish
endif
let g:autoloaded_gogh_ui = 1

let s:save_cpo = &cpo
set cpo&vim

" define interface
let s:edit_project_implement = {-> ''}
let s:switch_project_implement = {-> ''}
let s:get_repository_implement = {-> ''}

function! gogh#ui#edit_project() abort
  call s:edit_project_implement()
endfunction

function! gogh#ui#switch_project() abort
  call s:switch_project_implement()
endfunction

function! gogh#ui#get_repository() abort
  call s:get_repository_implement()
endfunction

function! gogh#ui#use(implements, vargs) abort
  if has_key(a:implements, 'edit_project') && index(a:vargs, 'edit_project') == -1
    let s:edit_project_implement = a:implements.edit_project
    command! GoghEditProject call gogh#ui#edit_project()
    nnoremap <silent> <plug>(gogh-edit-project) :<c-u>GoghEditProject<cr>
  endif

  if has_key(a:implements, 'switch_project') && index(a:vargs, 'switch_project') == -1
    let s:switch_project_implement = a:implements.switch_project
    command! GoghSwitchProject call gogh#ui#switch_project()
    nnoremap <silent> <plug>(gogh-switch-project) :<c-u>GoghSwitchProject<cr>
  endif

  if has_key(a:implements, 'get_repository') && index(a:vargs, 'get_repository') == -1
    let s:get_repository_implement = a:implements.get_repository
    command! GoghGetRepository call gogh#ui#get_repository()
    nnoremap <silent> <plug>(gogh-get-repository) :<c-u>GoghGetRepository<cr>
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
