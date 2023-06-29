-- Example configuration to run a specific formatter on file save
vim.api.nvim_exec([[
  augroup RunFormatterOnSave
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.h,*.hpp :silent !clang-tidy -p build --config-file=.clang-tidy -fix -fix-errors %
    autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx !prettier --write <afile>
  augroup END
]], false)

