let s:save_cpo = &cpo
set cpo&vim

function! open_android_studio#open_here() abort
  if &buftype == 'nofile'
    return
  endif
  const l:file = expand('%')
  const l:pos = getcursorcharpos()
  call open_android_studio#open(l:file, l:pos[1], l:pos[2])
endfunction

function! open_android_studio#open(path, line, column) abort
  const l:path = a:path->fnamemodify(':p')
  const l:basedir = l:path->fnamemodify(':h')
  const l:root = findfile('settings.gradle', $'{l:basedir};')
  if l:root->empty()
    return
  endif
  call s:start(['studio', l:root, '--line', a:line, '--column', a:column, l:path])
endfunction

if has('nvim')
  function s:start(cmd) abort
    call jobstart(a:cmd)
  endfunction
else
  function s:start(cmd) abort
    call job_start(a:cmd)
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo
