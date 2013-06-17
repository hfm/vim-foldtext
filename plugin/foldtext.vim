" Base {{{
function! Foldtext_base(...)
    " use the argument for display if possible, otherwise the current line {{{
    if a:0 > 0
        let line = a:1
    else
        let line = getline(v:foldstart)
    endif
    " }}}
    " remove the marker that caused this fold from the display {{{
    let foldmarkers = split(&foldmarker, ',')
    let line = substitute(line, '\V' . foldmarkers[0] . '\%(\d\+\)\?', ' ', '')
    " }}}
    " remove comments that vim knows about {{{
    let comment = split(&commentstring, '%s')
    if comment[0] != ''
        let comment_begin = comment[0]
        let comment_end = ''
        if len(comment) > 1
            let comment_end = comment[1]
        end
        let pattern = '\V' . comment_begin . '\s\*' . comment_end . '\s\*\$'
        if line =~ pattern
            let line = substitute(line, pattern, ' ', '')
        else
            let line = substitute(line, '.*\V' . comment_begin, ' ', '')
            if comment_end != ''
                let line = substitute(line, '\V' . comment_end, ' ', '')
            endif
        endif
    endif
    " }}}
    " remove any remaining leading or trailing whitespace {{{
    " let line = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
    let line = substitute(line, '\(.\{-}\)\s*$', '\1', '')
    " }}}
    " align everything, and pad the end of the display with - {{{
    " let alignment = &columns - 18 - v:foldlevel

    let cnt = printf('[ %5s ] ',  (v:foldend - v:foldstart + 1))
    let line_width = winwidth(0) - &foldcolumn

    if &number == 1
        let line_width -= max([&numberwidth, len(line('$'))])
    endif

    let alignment = line_width - len(cnt) - 3 - v:foldlevel
    let line = strpart(printf('%-' . alignment . 's', line), 0, alignment)
    let line = substitute(line, '\%( \)\@<= \%( *$\)\@=', ' ', 'g')
    " }}}
    " format the line count {{{
    " let cnt = printf('%15s', '[' . (v:foldend - v:foldstart + 1) . ' lines] ')
    " let cnt = printf(' %11s ',  (v:foldend - v:foldstart + 1) )
    " }}}
    return '+-' . v:folddashes . ' ' . line . cnt
endfunction
" }}}

if exists("g:Foldtext_enable") && g:Foldtext_enable
    set foldtext=Foldtext_base()
endif
