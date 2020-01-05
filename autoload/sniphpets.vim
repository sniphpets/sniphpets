if exists('g:sniphpets_autoload')
    finish
endif

let g:sniphpets_autoload = 1

" Resolve fully qualified name
fun! sniphpets#fqn()
    if exists('*phpactor#GetClassFullName')
        let fqn = phpactor#GetClassFullName()

        if !empty(fqn)
            return fqn
        endif
    endif

    let fqn = sniphpets#path_to_fqn(expand('%:p'))

    if exists('g:sniphpets_namespace_prefix')
        let fqn = g:sniphpets_namespace_prefix . '\' . fqn
    endif

    return fqn
endf

" @Deprecated: use sniphpets#fqn
fun! sniphpets#resolve_fqn()
    echom "sniphpets#resolve_fqn is deprecated! Use sniphpets#fqn."

    return sniphpets#fqn()
endf

" Resolve a namespace of the current php file
fun! sniphpets#namespace()
    let fqn = sniphpets#fqn()

    return sniphpets#head(fqn, '\', 'fromTheEnd')
endf

" @Deprecated: use sniphpets#namespace
fun! sniphpets#resolve_namespace()
    echom "sniphpets#resolve_namespace is deprecated! Use sniphpets#namespace."

    return sniphpets#namespace()
endf

" Converts file path to fully qualified name
fun! sniphpets#path_to_fqn(path)
    return substitute(substitute(tr(a:path, '/', '\'), '.php$', '', ''), '\v^.*\\\l[^\\]*\\?', '', '')
endf

" Return a string tail
" Example: tail('AppBundle\Entity', '\') will return 'Entity'
fun! sniphpets#head(str, delimiter, ...)
    let pos = a:0 > 0 ? strridx(a:str, a:delimiter) : stridx(a:str, a:delimiter)
    return pos < 0 ? '' : strpart(a:str, 0, pos)
endf

" Return a string head
" Example: head('AppBundle\Entity', '\') will return 'AppBundle'
fun! sniphpets#tail(str, delimiter, ...)
    let pos = a:0 > 0 ? stridx(a:str, a:delimiter) : strridx(a:str, a:delimiter)
    return pos < 0 ? '' : strpart(a:str, pos + strlen(a:delimiter))
endf

" Remove string tail if it exists
fun! sniphpets#remove_tail(str, tail)
    if strridx(a:str, a:tail) == strlen(a:str) - strlen(a:tail)
        return strpart(a:str, 0, strridx(a:str, a:tail))
    endif

    return a:str
endf

" Remove string head if it exists
fun! sniphpets#remove_head(str, head)
    if stridx(a:str, a:head) == 0
        return strpart(a:str, strlen(a:head))
    endif

    return a:str
endf

" Get settings
fun! sniphpets#settings(name, ...)
    let var_name = printf('g:sniphpets_%s', a:name)

    if exists(var_name)
        let value = eval(var_name)
    else
        let value = a:0 > 0 ? a:1 : ''
    endif

    return value
endf

fun sniphpets#lcfirst(str)
    return substitute(a:str, '^\u', '\l\0', '')
endf

fun sniphpets#ucfirst(str)
    return substitute(a:str, '^\l', '\u\0', '')
endf

" Convert 'camelCase' to 'snake_case'
fun! sniphpets#camel_to_snake(camel, ...)
    let s = a:0 > 0 ? a:1 : '_'

    " Handle first letter
    let snake = substitute(a:camel, '^\(\u\)', '\l\1', '')

    " Handle slashes
    let snake = substitute(snake, '\(/\|\\\)\(\u\)', '\1\l\2', 'g')

    return substitute(snake, '\(\u\)', s . '\l\1', 'g')
endf

" Get basename of the current file
fun! sniphpets#basename(...)
    let basename = expand('%:t:r')

    if a:0 > 0
       let basename = sniphpets#remove_tail(basename, a:1)
    endif

    return basename
endf

" Returns the current (closest) method's name
fun! sniphpets#method()
    let line = search('\(public\|protected\|private\).*function' ,'bn')

    if line > 0
        return substitute(getline(line), '^.*function \(.*\)(.*$', '\1' , '')
    endif

    return ''
endf

" Return file-level header
fun! sniphpets#header()
    let header = get(g:, 'sniphpets_header', '')

    if get(g:, 'sniphpets_strict_types', 0)
        let header = printf("%s%sdeclare(strict_types=1);", header, strlen(header) ? "\n\n" : '')
    endif

    if strlen(header)
        let header = printf("\n\n%s", header)
    endif

    return header
endf
