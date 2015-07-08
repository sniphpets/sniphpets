if exists('g:sniphpets_unittest_autoload')
    finish
endif

let g:sniphpets_unittest_autoload = 1

fun! sniphpets#unittest#resolve_alternate(...)
    let fqn = a:0 > 0 ? a:1 : sniphpets#resolve_fqn()

    let unittest_namespace = sniphpets#settings('unittest_namespace', 'Tests?')
    let unittest_suffix = sniphpets#settings('unittest_suffix', 'Test')

    let alternate = substitute(substitute(fqn, printf('\v(^|\\)%s\\', unittest_namespace), '\1', ''), printf('\v%s$', unittest_suffix), '', '')

    if alternate == fqn
       return '' 
    endif

    return substitute(alternate, '^\', '', '')
endf
