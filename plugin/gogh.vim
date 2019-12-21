" gogh.vim - gogh (GO GitHub project manager) for vim
" Maintainer:   kyoh86
" License:		MIT License(http://www.opensource.org/licenses/MIT)

if exists('g:loaded_gogh')
  finish
endif
let g:loaded_gogh = 1

let s:save_cpo = &cpo
set cpo&vim

" noop

let &cpo = s:save_cpo
unlet s:save_cpo
