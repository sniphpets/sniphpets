set rtp+=',/tmp/phpactor'

fun! phpactor#GetClassFullName()
    return get(g:, 'phpactor_fqn', 'FQN')
endf
