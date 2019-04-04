" gogh.vim - gogh (GO GitHub project manager) for vim
" Maintainer:   kyoh86
" License:      This file is placed in the public domain.

if exists('g:loaded_gogh')
  finish
endif
let g:loaded_gogh = 1

let s:save_cpo = &cpo
set cpo&vim

" FZF {{{
function! s:edit_project_callback(repo)
  let l:edit = get(g:, 'gogh_edit_project_command', 'edit')
  call gogh#edit(a:repo, l:edit)
endfunction
function! s:switch_project_callback(repo)
  let l:cd = get(g:, 'gogh_switch_project_command', 'cd')
  call gogh#cd(a:repo, l:cd)
endfunction
function! gogh#def_fzf_commands()
  command! GoghEditProject call fzf#run({
      \ 'source': gogh#list(),
      \ 'sink': function('<SID>edit_project_callback'),
      \ 'down': '30%'
      \ })
  nnoremap <silent> <plug>(gogh-edit-project) :<c-u>GoghEditProject<cr>

  command! GoghSwitchProject call fzf#run({
      \ 'source': gogh#list(),
      \ 'sink': function('<SID>switch_project_callback'),
      \ 'down': '30%'
      \ })
  nnoremap <silent> <plug>(gogh-switch-project) :<c-u>GoghSwitchProject<cr>

  command! GoghGetRepository call fzf#run({
      \ 'source': gogh#repo(),
      \ 'sink': function('gogh#get'),
      \ 'down': '30%'
      \ })
  nnoremap <silent> <plug>(gogh-get-repository) :<c-u>GoghGetRepository<cr>
endfunction
" }}}

call gogh#def_fzf_commands()  " TODO: support ctrlp.vim instead of fzf

let &cpo = s:save_cpo
unlet s:save_cpo
