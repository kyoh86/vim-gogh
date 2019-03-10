" gogh.vim - gogh (GO GitHub project manager) for vim
" Maintainer:   kyoh86
" License:      This file is placed in the public domain.

if exists('g:autoloaded_gogh')
  finish
endif
let g:autoloaded_gogh = 1

let s:save_cpo = &cpo
set cpo&vim

" Function: gogh#repo will get a list of remote repositories
" Options:
"  - g:gogh_params_repo_user        : Who has the repositories. Default: the authenticated user
"  - g:gogh_params_repo_own         : Include repositories that are owned by the user (0 or 1). Default: 1
"  - g:gogh_params_repo_collaborate : Include repositories that the user has been added to as a collaborator (0 or 1). Default: 0
"  - g:gogh_params_repo_member      : Include repositories that the user has access to through being a member of an organization.
"                               This includes every repository on every team that the user is on (0 or 1). Default: 1
"  - g:gogh_params_repo_visibility  : Include repositories that can be access (public, private or all). Default: all
"  - g:gogh_params_repo_sort        : Sort repositories by (created, updated, pushed or full_name). Default: full_name
"  - g:gogh_params_repo_direction   : Sort direction (asc, desc or default). Default: default
function! gogh#repo() abort
  let l:user        = get(g:, 'gogh_params_repo_user')

  let l:own         = get(g:, 'gogh_params_repo_own')
  let l:collaborate = get(g:, 'gogh_params_repo_collaborate')
  let l:member      = get(g:, 'gogh_params_repo_member')

  let l:visibility  = get(g:, 'gogh_params_repo_visibility')
  let l:sort        = get(g:, 'gogh_params_repo_sort')
  let l:direction   = get(g:, 'gogh_params_repo_direction')

  let l:cmd = ['gogh', 'repo']
  if (l:own)
    let l:cmd += ['--own']
  endif
  if (l:collaborate)
    let l:cmd += ['--collaborate']
  endif
  if (l:member)
    let l:cmd += ['--member']
  endif
  if (l:user)
    let l:cmd += ['--user', l:user]
  endif
  if (l:visibility)
    let l:cmd += ['--visibility', l:visibility]
  endif
  if (l:sort)
    let l:cmd += ['--sort', l:sort]
  endif
  if (l:direction)
    let l:cmd += ['--direction', l:direction]
  endif

  let l:cmd = join(l:cmd)
  echo 'Calling '.l:cmd.'...'

  return split(system(l:cmd), '[\n\r]\+')
endfunction

function! gogh#get(repository)
  let l:cmd = 'gogh get '.a:repository
  echo l:cmd
  echo system(l:cmd)
endfunction

" Function: gogh#list will get a list of projects
" Options:
"  - g:gogh_params_list_format : specify output format (relative, full or short). Default: relative
"  - g:gogh_params_list_primary : only in primary root directory (0 or 1). Default: 0
function! gogh#list() abort
  let l:format = get(g:, 'gogh_params_list_format')
  let l:primary = get(g:, 'gogh_params_list_primary')

  let l:cmd = ['gogh', 'list']
  if (l:format)
    let l:cmd += ['--format', l:format]
  endif
  if (l:primary)
    let l:cmd += ['--primary']
  endif

  let l:cmd = join(l:cmd)
  echo 'Calling '.l:cmd.'...'

  return split(system(l:cmd), '[\n\r]\+')
endfunction

function! gogh#cd(project)
  let l:cmd = 'cd '.substitute(system('gogh where '.a:project), '[\n\r]\+$', '', '')
  echo l:cmd
  exec l:cmd
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
