ASYNC.run(function ()
  require'nvim-treesitter.configs'.setup {
    sync_install = true,
    ensure_installed = {
      'bash',
      'c',
      'dockerfile',
      'go',
      'javascript',
      'json',
      'kotlin',
      'lua',
      'make',
      'markdown',
      'python',
      'sql',
      'tsx',
      'typescript',
      'vim',
      'yaml',
    },
  }
end)

