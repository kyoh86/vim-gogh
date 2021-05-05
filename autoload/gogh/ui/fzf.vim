" gogh.vim - gogh (GO GitHub project manager) for vim
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:autoloaded_gogh_ui_fzf')
  finish
endif
let g:autoloaded_gogh_ui_fzf = 1

let s:save_cpo = &cpo
set cpo&vim

let s:separator = '\t'

" Function: gogh#ui#fzf#use 
" Description: use FZF for gogh UI
function! gogh#ui#fzf#use(...)
  let l:implements = {}

  function! l:implements.fzf_option()
    return {
      \ 'source': 'gogh list --format fields',
      \ 'options': ['--delimiter', s:separator, '--with-nth', '4'],
      \ 'split_path': self.split_path
      \ }
  endfunction

  function! l:implements.split_path(line) abort
    let [l:target; _] = split(a:line, s:separator)
    return fnameescape(l:target)
  endfunction

  function! l:implements.edit_project() abort
    let l:opts = self.fzf_option()

    let l:default_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
    let l:action = get(g:, 'fzf_action', l:default_action)
    let l:opts['options'] += ['--expect', join(keys(l:action), ',')]
    let l:opts['_action'] = l:action

    function! l:opts.sink(lines) abort
      if len(a:lines) != 2
        return
      endif
      let l:key = remove(a:lines, 0)
      let l:cmd = get(self._action, l:key, 'edit')

      let l:target = self.split_path(a:lines[0])

      if type(l:cmd) == type(function('call'))
        return l:cmd(l:target)
      endif

      execute l:cmd l:target
    endfunction

    " just sink* can accept multiple line (0:key and 1:selection)
    " but function 'l:opts.sink*' cannot be defined.
    " so first, defines l:opts.sink, and move it to 'sink*'.
    let l:opts['sink*'] = remove(l:opts, 'sink')

    call fzf#run(fzf#wrap(l:opts))
  endfunction

  function! l:implements.switch_project()
    let l:opts = self.fzf_option()

    function! l:opts.sink(line) abort
      let l:target = self.split_path(a:line)
      let l:switch = get(g:, 'gogh_switch_project_command', 'cd')
      execute l:switch l:target
    endfunction

    call fzf#run(fzf#wrap(l:opts))
  endfunction

  function! l:implements.get_repository()
    " UNDONE: use options on 'gogh repo'
    let l:opts = {
      \ 'source': 'gogh repo', 
      \ }
    function! l:opts.sink(line) abort
      echo system('gogh get ' . a:line)
    endfunction

    call fzf#run(fzf#wrap(l:opts))
  endfunction

  call gogh#ui#use(l:implements, a:000)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
