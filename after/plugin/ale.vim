ALEEnable

function! FormatSQL(buffer) abort
    return {
    \   'command': '~/.config/nvim/formatters/pgFormatter-5.5/pg_format -'
    \}
endfunction

execute ale#fix#registry#Add('sqlfmt', 'FormatSQL', ['sql'], 'pg_format for sql')

let g:ale_fixers = {
\   'typescript': ['prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'json': ['prettier'],
\   'md': ['prettier'],
\   'sql': ['sqlfmt'],
\   'c': ['clang-format', 'clangtidy'],
\}

let g:ale_fix_on_save = 1

let g:ale_linters_explicit = 1
let g:ale_enabled = 0
