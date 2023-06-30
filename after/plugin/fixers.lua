-- Example configuration to run a specific formatter on file save
vim.api.nvim_exec([[
  augroup RunFormatterOnSave
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.h,*.hpp :silent !clang-tidy -p build --config-file=.clang-tidy -fix -fix-errors % && clang-format -i -style=file %
    autocmd BufWritePost *.js,*.jsx,*.ts,*.tsx,*.html,*.css :silent !prettier --write <afile>
    autocmd BufWritePost *.sql :silent !pg_format -i <afile>
    autocmd BufWritePost *.sh :silent !shfmt -w <afile>
  augroup END
]], false)

