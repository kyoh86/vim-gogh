" gogh.vim - gogh (GO GitHub project manager) for vim
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:autoloaded_gogh')
  finish
endif
let g:autoloaded_gogh = 1

let s:save_cpo = &cpo
set cpo&vim

" Function: gogh#repo will get a list of remote repositories
" Params:
"  - options:
"    - user        : Who has the repositories. Default: the authenticated user
"    - own         : Include repositories that are owned by the user (0 or 1). Default: 1
"    - collaborate : Include repositories that the user has been added to as a collaborator (0 or 1). Default: 0
"    - member      : Include repositories that the user has access to through being a member of an organization.
"              This includes every repository on every team that the user is on (0 or 1). Default: 1
"    - visibility  : Include repositories that can be access (public, private or all). Default: all
"    - sort        : Sort repositories by (created, updated, pushed or full_name). Default: full_name
"    - direction   : Sort direction (asc, desc or default). Default: default
function! gogh#repo(options) abort
  let l:user        = get(a:options, 'user')

  let l:own         = get(a:options, 'own')
  let l:collaborate = get(a:options, 'collaborate')
  let l:member      = get(a:options, 'member')

  let l:visibility  = get(a:options, 'visibility')
  let l:sort        = get(a:options, 'sort')
  let l:direction   = get(a:options, 'direction')

  let l:cmd = ['gogh', 'repo']

  if l:own !=# ''
    let l:cmd += ['--own']
  endif
  if l:collaborate !=# ''
    let l:cmd += ['--collaborate']
  endif
  if l:member !=# ''
    let l:cmd += ['--member']
  endif
  if l:user !=# ''
    let l:cmd += ['--user', l:user]
  endif
  if l:visibility !=# ''
    let l:cmd += ['--visibility', l:visibility]
  endif
  if l:sort !=# ''
    let l:cmd += ['--sort', l:sort]
  endif
  if l:direction !=# ''
    let l:cmd += ['--direction', l:direction]
  endif

  let l:cmd = join(l:cmd)
  echo 'Calling '.l:cmd.'...'

  return split(system(l:cmd), '[\n\r]\+')
endfunction

" Function: gogh#list will get a list of projects
" Params:
"  - options:
"    - format : specify output format (relative, full or short). Default: relative
"    - primary : only in primary root directory (0 or 1). Default: 0
function! gogh#list(options) abort
  let l:format = get(a:options, 'format', 'short')
  let l:primary = get(a:options, 'primary')

  let l:cmd = ['gogh', 'list']
  if l:format !=# ''
    let l:cmd += ['--format', l:format]
  endif
  if l:primary !=# ''
    let l:cmd += ['--primary']
  endif

  let l:cmd = join(l:cmd)
  echo 'Calling '.l:cmd.'...'

  return split(system(l:cmd), '[\n\r]\+')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
