require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'bash',
    'graphql',
    'javascript',
    'json',
    'lua',
    'python',
    'vim',
    'sql',
    'tsx',
    'typescript',
    'yaml',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
