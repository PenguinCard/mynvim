call plug#begin('~/.vim')
" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

" nvim-treesitter
Plug 'nvim-treesitter/nvim-treesitter'

" NvimTree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Nerdcommenter
Plug 'preservim/nerdcommenter'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" syntastic
Plug 'tpope/vim-pathogen'
Plug 'vim-syntastic/syntastic'

" surround
Plug 'kylechui/nvim-surround'
" repeat
Plug 'tpope/vim-repeat'

" git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'APZelos/blamer.nvim'

" multi cursor
Plug 'mg979/vim-visual-multi'

" tokyonight theme
Plug 'folke/tokyonight.nvim'

" startify
Plug 'mhinz/vim-startify'

" minimap
Plug 'wfxr/minimap.vim'

" ack
Plug 'mileszs/ack.vim'

" eslint
Plug 'eslint/eslint'

" tagbar
Plug 'preservim/tagbar'

" csv
Plug 'chrisbra/csv.vim'

" indent
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'

" lsp
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'

" nvim-cmp
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" vim spector => nvim-dap
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'jbyuki/one-small-step-for-vimkind'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
call plug#end()
filetype plugin indent on

execute pathogen#infect()

lua <<EOF
  vim.cmd[[colorscheme tokyonight]]
  local pythonBinPath = '/bin/python3'
  if vim.fn.executable('/usr/local/Caskroom/miniforge/base' .. pythonBinPath) == 1 then
    pythonPath = '/usr/local/Caskroom/miniforge/base' .. pythonBinPath
  elseif vim.fn.executable('/opt/homebrew/Caskroom/miniforge/base' .. pythonBinPath) == 1 then
    pythonPath = '/opt/homebrew/Caskroom/miniforge/base' .. pythonBinPath
  elseif vim.fn.executable('/opt/homebrew' .. pythonBinPath) == 1 then
    pythonPath = '/opt/homebrew' .. pythonBinPath
  else
    pythonPath = '/usr/local' .. pythonBinPath
  end 

  require'dap-python'.setup(pythonPath) 
  require'nvim-surround'.setup()
  require'nvim-lsp-installer'.setup ()
	require'nvim-tree'.setup ()
  -- nvim-cmp.
  local cmp = require'cmp'
  -- lspconfig
  local lspconfig = require'lspconfig'
  -- nvim-dap
  local dap = require'dap'
  local dapui = require'dapui'
  local dapvirtualtext = require'nvim-dap-virtual-text'
  
  dapui.setup()
  dapvirtualtext.setup()

	require'nvim-treesitter.configs'.setup { 
    ensure_installed = { 
      'bash',
      'css',
      'graphql',
      'html',
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
    sync_install = true,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }

  -- setup nvim-lspconfig
  local opts = {
    noremap=true,
    silent=true,
  }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings.
    local bufopts = { 
      noremap=true,
      silent=true,
      buffer=bufnr
    }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  end
 
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users. 
      end,
    }, 
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  local languages = {
    'bashls',
    'tsserver',
    'dockerls',
    'jedi_language_server',
    'yamlls',
    'jsonls',
    'vimls',
    'sqlls',
    'sumneko_lua',
  }

  for idx, language in ipairs(languages) do 
    lspconfig[language].setup { on_attach = on_attach, capabilities = capabilities }
  end
 
  -- adapter
  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
  } 
  -- config
  dap.configurations.javascript = {
    {
      name = 'Launch',
      type = 'node2',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = 'Attach to process',
      type = 'node2',
      request = 'attach',
      processId = require'dap.utils'.pick_process,
    },
  } 
  dap.configurations.lua = { 
    { 
      type = 'nlua', 
      request = 'attach',
      name = "Attach to running Neovim instance",
      host = function()
        local value = vim.fn.input('Host [127.0.0.1]: ')
        if value ~= "" then
          return value
        end
        return '127.0.0.1'
      end,
      port = function()
        local val = tonumber(vim.fn.input('Port: '))
        return val
      end,
    }
  }
  dap.adapters.nlua = function(callback, config)
    if config.port ~= nil then
      callback({
        type = 'server',
        host = config.host,
        port = config.port
      })
    else
      require'osv'.run_this()
    end
  end

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
EOF

set nocompatible
" zsh
set shell=zsh
" automatic read
set autoread
" highlight search
set hlsearch
" when you search keyword, ignore case
set ignorecase
" column Line
set colorcolumn=89

" Line Number
set nu

set autoindent
set cindent

" tab space = 2
set ts=2
set sts=2
set shiftwidth=2
set tabstop=2
set expandtab
set shiftwidth=2

" smart setting
set smartcase
set smarttab
set smartindent

set cursorline

set showmatch

set ruler

set clipboard=unnamed

set fileencodings=utf8
set encoding=UTF-8

" use mouse
set mouse=a

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

set termguicolors " this variable must be enabled for colors to be applied properly

set background=dark

let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_typescript_checkers = ['eslint']
let g:syntastic_python_checkers = ['flake8']

function! SyntasticCheckHook(errors)
  if !empty(a:errors)
    let g:syntastic_loc_list_height = min([len(a:errors), 1])
  endif
endfunction

" ctrlp ignored git node_modules DS_Store
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|__pycache__'  
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#ctrlp#enabled = 1
let g:airline#extensions#csv#enabled = 1
let g:airline_powerline_fonts = 1

" git blame
let g:blamer_date_format = '%y/%m/%d %H:%M'
let g:blamer_delay = 250

" Nerdcommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_java = 1
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1

let g:indent_guides_auto_colors = 1
let g:indent_guides_enable_on_vim_startup = 1

" minimap
let g:minimap_width = 10
let g:minimap_auto_start_win_enter = 1
let g:minimap_block_filetypes = ['fugitive', 'nvim-tree', 'tagbar', 'ctrlp' ]
let g:minimap_close_filetypes = ['startify', 'vim-plug']
let g:minimap_git_colors =  1

" Ack
let g:ackhighlight = 1
let g:ack_autoclose = 1

let mapleader = ","

if has("syntax")
  syntax on
endif

" Ack
nnoremap <Leader>fj :Ack --js
nnoremap <Leader>fp :Ack --py
nnoremap <Leader>fs :Ack --shell

" ========= toggle =========
" tagbar
nnoremap <Leader>tt :TagbarToggle<CR>
" minimap
nnoremap <Leader>mt :MinimapToggle<CR>
" dap
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
" dap ui
nnoremap <Leader>dt <Cmd>lua require("dapui").toggle()<CR>
" git blame
nnoremap <Leader>bt :BlamerToggle<CR>
" nvim-tree
nnoremap <Leader>nt :NvimTreeToggle<CR>
" ==========================

" Fugtive
nnoremap <Leader>ga :G add
nnoremap <Leader>gaa :G add .<CR>
nnoremap <Leader>gb :G branch<CR>
nnoremap <Leader>gbd :G branch -d
nnoremap <Leader>gcm :G commit -m
nnoremap <Leader>gco :G checkout
nnoremap <Leader>gl :G pull
nnoremap <Leader>gp :G push<CR>
nnoremap <Leader>grh :G reset HEAD<CR>
nnoremap <Leader>grs :G restore
nnoremap <Leader>gst :G status<CR>
" nvim-tree
nnoremap <Leader>nr :NvimTreeRefresh<CR>
nnoremap <Leader>nf :NvimTreeFindFile<CR>
" buf
nnoremap <Leader>bp :bprev<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bdd :bdelete<CR>
nnoremap <Leader>bh :sb<CR>
nnoremap <Leader>bv :vs<CR>
nnoremap <Leader>bda :bufdo bd<CR>
" tab
nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>td :tabclose<CR>
nnoremap <Leader>tp :tabprev<CR>
nnoremap <Leader>tn :tabnext<CR>
" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
" nvim-dap
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
" nvim-dap-python
nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR>
vnoremap <silent> <leader>ds <ESC> :lua require('dap-python').debug_selection()<CR>
" nvim-dap-ui
vnoremap <Leader>ev <Cmd>lua require("dapui").eval()<CR>
