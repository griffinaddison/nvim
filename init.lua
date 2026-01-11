-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

--- Set up leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"                     -- todo: understand this
vim.opt.guifont = "JetBrainsMono Nerd Font:h14" -- Adjust the size (h14)

--- General settings

-- disable netrw file explorer in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim-smoothie linear scroll
vim.g.smoothie_exponential_factor = 1.0


vim.api.nvim_set_option("clipboard", "unnamedplus") -- Merge nvim and linux clipboards
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true -- turn tab into space, to prevent different editors (and github) from screwing up spacing w/ different tab -> space ratio
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- -- Enable autoindent (match prev line indent) and smartindent (auto indent after : and stuff)
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true

-- <leader><Tab><Tab> to show tabs
vim.opt.listchars = "tab:▷▷⋮"
vim.api.nvim_set_keymap('n', '<Leader><Tab><Tab>', ':set invlist<CR>', { noremap = true, silent = true })


-- :bnext, :bprev
vim.keymap.set('n', '[b', ':bprev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', ']b', ':bnext<CR>', { noremap = true, silent = true })

-- vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

---- smart-splits.nvim
-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`


-- tab and shift tab indents in insert mode for markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Tab: indent bullet
    vim.api.nvim_buf_set_keymap(0, "i", "<Tab>", "<C-t>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "i", "<S-Tab>", "<C-d>", { noremap = true })
    -- auto indent: match prev line; smart indent: indent after : and stuff
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
  end,
})
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })


vim.keymap.set("n", "<leader>h", ":ClangdSwitchSourceHeader<CR>",
  { noremap = true, silent = true, desc = "Switch between source and header" })
-- vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })   -- List open buffers
vim.keymap.set("n", "<leader>rf", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true }) -- List recent files

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, silent = true, desc = "Open Oil file explorer" })

-- Toggle comment for the current line
vim.keymap.set("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
  { noremap = true, silent = true })

-- Toggle comment for a visual selection
vim.keymap.set("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { noremap = true, silent = true })

-- gitsigns stuff
vim.keymap.set("n", "<leader>sh", function() require("gitsigns").stage_hunk() end,
  { noremap = true, silent = true, desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>ush", function() require("gitsigns").undo_stage_hunk() end,
  { noremap = true, silent = true, desc = "Undo Stage Hunk" })
vim.keymap.set("n", "<leader>rh", function() require("gitsigns").reset_hunk() end,
  { noremap = true, silent = true, desc = "Reset Hunk" })
vim.keymap.set("v", "<leader>sh", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
  { noremap = true, silent = true, desc = "Stage Hunk (Visual)" })
vim.keymap.set("v", "<leader>ush",
  function() require("gitsigns").undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
  { noremap = true, silent = true, desc = "Stage Hunk (Visual)" })
vim.keymap.set("v", "<leader>rh", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
  { noremap = true, silent = true, desc = "Reset Hunk (Visual)" })
-- vim.keymap.set("n", "<leader>gsS", function() require("gitsigns").stage_buffer() end, { noremap = true, silent = true, desc = "Stage Buffer" })
-- vim.keymap.set("n", "<leader>ush", function() require("gitsigns").undo_stage_hunk() end, { noremap = true, silent = true, desc = "Undo Stage Hunk" })
-- vim.keymap.set("n", "<leader>gsR", function() require("gitsigns").reset_buffer() end, { noremap = true, silent = true, desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>vh", function() require("gitsigns").preview_hunk_inline() end,
  { noremap = true, silent = true, desc = "Preview Hunk Inline" })
vim.keymap.set("n", "<leader>nh", function() require("gitsigns").next_hunk() end,
  { noremap = true, silent = true, desc = "Next Hunk" })
vim.keymap.set("n", "<leader>ph", function() require("gitsigns").prev_hunk() end,
  { noremap = true, silent = true, desc = "Prev Hunk" })
-- vim.keymap.set("n", "<leader>gsb", function() require("gitsigns").blame_line({ full = true }) end, { noremap = true, silent = true, desc = "Blame Line (Full)" })
vim.keymap.set("n", "<leader>tb", function() require("gitsigns").toggle_current_line_blame() end,
  { noremap = true, silent = true, desc = "Toggle Current Line Blame" })
-- vim.keymap.set("n", "<leader>gsd", function() require("gitsigns").diffthis() end, { noremap = true, silent = true, desc = "Diff This" })
-- vim.keymap.set("n", "<leader>gsD", function() require("gitsigns").diffthis("~") end, { noremap = true, silent = true, desc = "Diff This (~)" })

-- -- folding
-- vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, { noremap = true, silent = true, desc = "Open All Folds" })
-- vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, { noremap = true, silent = true, desc = "Close All Folds" })
-- vim.keymap.set("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { noremap = true, silent = true, desc = "Open Fold Levels" })
-- vim.keymap.set("n", "zm", function() require("ufo").closeFoldsWith() end, { noremap = true, silent = true, desc = "Close Fold Levels" })

vim.keymap.set("n", "<leader>td", function() require("gitsigns").toggle_deleted() end,
  { noremap = true, silent = true, desc = "Toggle Deleted" })

-- How much to 'conceal' formatting characters in, for example, .md files. 0, 1, or 2
vim.opt.conceallevel = 1


-- Cellular automation
vim.keymap.set("n", "<leader><leader><leader>", "<cmd>CellularAutomaton make_it_rain<CR>")


-- Tab and Shift-Tab for tab navigation in Normal mode
vim.keymap.set('n', '<leader><Tab>', ':tabnext<CR>', { desc = 'Go to next tab page' })
vim.keymap.set('n', '<leader><S-Tab>', ':tabprevious<CR>', { desc = 'Go to previous tab page' })


-- folding
vim.o.foldcolumn = "1"    -- Show fold column
vim.o.foldlevel = 99      -- Set a high fold level to keep folds open by default
vim.o.foldlevelstart = 99 -- Start with all folds open
vim.o.foldenable = true   -- Enable folding

-- Copilot: <leader><Tab> normal mode to toggle, <Tab> insert mode to accept
local function toggle_copilot_auto_trigger()
  local copilot = require("copilot.suggestion")
  -- Toggle auto-trigger
  copilot.toggle_auto_trigger()
  vim.notify("copilot toggled", vim.log.levels.INFO, { title = "Copilot" })
end
vim.keymap.set("n", "<leader>cp", toggle_copilot_auto_trigger, { noremap = true, silent = true })
local function accept_copilot_or_tab()
  -- Check if a Copilot suggestion is available
  local copilot = require("copilot.suggestion")
  if copilot.is_visible() then
    -- Accept the suggestion if visible
    copilot.accept()
  else
    -- Otherwise, insert a tab character
    return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
  end
end
vim.keymap.set("i", "<Tab>", accept_copilot_or_tab, { expr = true, noremap = true })


-- Use docker ls for these file names:
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*docker-compose.yaml", "*docker-compose.yml" },
  callback = function()
    vim.bo.filetype = "yaml.docker-compose"
  end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Dockerfile*", "*/Dockerfile*" }, -- Covers Dockerfile, Dockerfile.dev, etc.
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})



-- jrnl syncing
vim.api.nvim_create_augroup("JrnlSync", { clear = true })

-- sync on save
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "JrnlSync",
  pattern = vim.fn.expand("~") .. "/jrnl/*",
  callback = function()
    vim.fn.system('git-auto-sync sync')
    -- Show a confirmation message
    -- vim.api.nvim_echo({ { "synced using git-auto-sync" } }, false, {})
    -- vim.print({ { "synced using git-auto-sync" } }, false, {})
    -- vim.notify("Synced using git-auto-sync", vim.log.levels.INFO)
  end,
})

-- sync on open
vim.api.nvim_create_autocmd("BufReadPre", {
  group = "JrnlSync",
  pattern = vim.fn.expand("~") .. "/jrnl/*",
  callback = function()
    vim.fn.system('git-auto-sync sync')
    -- Show a confirmation message
    -- vim.api.nvim_echo({ { "synced using git-auto-sync" } }, false, {})
    -- vim.print({ { "synced using git-auto-sync" } }, false, {})
    -- vim.notify("Synced using git-auto-sync", vim.log.levels.INFO)
  end,
})

-- 🔽 new one: disable swapfile for jrnl markdown
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = "JrnlSync",  -- you can reuse the group, no problem
  pattern = vim.fn.expand("~") .. "/jrnl/*.md",
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = true
  end,
})

-- disable line wrapping in md file for readability
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "copilot-chat",
  callback = function()
    vim.schedule(function()
      -- Safely delete conflicting mappings
      pcall(vim.keymap.del, "n", "<C-l>", { buffer = true })
      pcall(vim.keymap.del, "i", "<C-l>", { buffer = true })

      -- Set your preferred navigation
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
      vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
      vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
      vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
      -- vim.keymap.set("i", "<C-h>", "<Esc><Cmd>wincmd h<CR>", opts)
      -- vim.keymap.set("i", "<C-j>", "<Esc><Cmd>wincmd j<CR>", opts)
      -- vim.keymap.set("i", "<C-k>", "<Esc><Cmd>wincmd k<CR>", opts)
      -- vim.keymap.set("i", "<C-l>", "<Esc><Cmd>wincmd l<CR>", opts)
    end)
  end,
})



-- make smart splits work in oil.nvim window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    local smart_splits = require("smart-splits")
    -- Remap inside oil.nvim buffer
    vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { buffer = true })
    vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { buffer = true })
    vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { buffer = true })
    vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { buffer = true })
  end,
})




-- copilot chat
vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChat<CR>", { noremap = true, silent = true })

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4, -- Space between code and virtual text
    severity_sort = true,
    format = function(diagnostic)
      local severity_map = {
        [vim.diagnostic.severity.ERROR] = "ERROR",
        [vim.diagnostic.severity.WARN] = "WARN",
        [vim.diagnostic.severity.INFO] = "INFO",
        [vim.diagnostic.severity.HINT] = "HINT",
      }
      -- Prepend the severity name to the message
      local severity_label = severity_map[diagnostic.severity] or "UNKNOWN"
      return string.format("%s", severity_label)
    end,
  },
  float = {
    source = "always", -- Show the source of the diagnostic in floating windows
    severity_sort = true,
  },
  signs = true,             -- Show diagnostic signs in the sign column
  underline = true,         -- Underline diagnostics in the code
  update_in_insert = false, -- Update diagnostics only after leaving insert mode
})



-- Gitsigns: Define the helper for visual mode operations
local function gitsigns_visual_op(op)
  return function()
    return require('gitsigns')[op]({ vim.fn.line("."), vim.fn.line("v") })
  end
end




--- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here

    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
      },
    },

    -- file explorer
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup({
          git = {
            enable = true,
            ignore = false, -- ensure git-ignored files are shown (like build)	
          },
          view = { relativenumber = true },
        })
      end,
    },



    -- Syntax tree: more advanced syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          highlight = {
            enable = true,
            -- disable = { "markdown" },
            additional_vim_regex_highlighting = false,
          },
          -- indent = { enable = true,
          --           disable="markdown",
          -- },
          -- ensure_installed = { "lua", "cpp", "python", "markdown" },
          -- ensure_installed = { "lua", "cpp", "python"},
          ensure_installed = { "lua", "cpp", "python", "markdown", "markdown_inline"},
        })
      end
    },

    {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require('treesitter-context').setup {
          -- Your custom configurations go here
          mode = 'topline',
          max_lines = 10,
          trim_scope = 'outer',
          -- ... other options ...
        }
      end,
    },

    { 'nvim-lua/plenary.nvim' },


    -- Fuzzy finder (for files and words)
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("telescope").setup({
          defaults = {
            path_display = { 'filename_first' },
            file_ignore_patterns = { -- File patterns to ignore in telescope search

              -- general
              "%.git/",
              "%.cache",
              "CMakeFiles",
              "CMakeCache%.txt$",

              -- ROS2
              "^build$", -- Note: ^ensures start of string, $ ensures end
              "^install$",
              "^log$",
              "%.repos$",
              "%.log$"
            },

            vimgrep_arguments = {
              'rg',
              '--color=never',
              '--no-heading',
              '--with-filename',
              '--line-number',
              '--column',
              '--smart-case',
              '--no-ignore' -- Add this line to ignore .gitignore
            }
          },
          extensions = {
            fzf = {
              fuzzy = true,                   -- false will only do exact matching
              override_generic_sorter = true, -- override the generic sorter
              override_file_sorter = true,    -- override the file sorter
              case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
              -- the default case_mode is "smart_case"
            }
          }
        })
        -- Load the fzf extension after setup
        require('telescope').load_extension('fzf')
      end
    },

    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },

    -- LSP configuration (LSP scans codebase and lines declarations w/ implementaitions, does some syntax highlighting)
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({

          on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }

            -- Key mappings for LSP actions
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
            -- Keybinding for formatting
            vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, bufopts)
          end,

        })
        lspconfig.pyright.setup({

          on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }

            -- Key mappings for LSP actions
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
          end,

          settings = {
            python = {
              analysis = {
                extraPaths = { "ros_utilities" },
                diagnosticmode = "workspace",
              }
            }
          }
        })

        lspconfig.cmake.setup({
          cmd = { "cmake-language-server" }, -- If not in PATH
          -- on_attach = your_custom_on_attach_function, -- For custom keybindings, etc.
          -- capabilities = your_custom_capabilities,
          -- init_options = {
          --   buildDirectory = "build_custom" -- Example init_option
          -- }
        })

        -- need to fix the commands for docker language server
        lspconfig.docker_compose_language_service.setup({
          cmd = { "docker-language-server", "start", "--stdio" },
        })
        lspconfig.dockerls.setup({
          cmd = { "docker-language-server", "start", "--stdio" },
        })


        -- Prevent err "multiple client offset encodings" conflict b/w clangd and copilot
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.offsetEncoding = { "utf-16" }
        lspconfig.clangd.setup({
          -- cmd = { "clangd", "--clang-tidy=false" }, -- disable built in clang-tidy, as i installed it separately

          cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }

            -- Key mappings for LSP actions
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

            -- Keybinding for formatting
            vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, bufopts)

            -- -- format on save	
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            -- 	buffer = bufnr,
            -- 	callback = function()
            -- 		vim.lsp.buf.format({ async = true })
            -- 	end,
            -- })
          end,


        })
        lspconfig.opts = {
          servers = {
            clangd = {
              mason = false,
            },
          },
        }
      end
    },
    {
      "mfussenegger/nvim-lint",
      config = function()
        require("lint").linters_by_ft = {
          cpp = { "clangtidy" },
        }

        require("lint").linters.clangtidy.args = { "-p", "build" }
        -- Run linting on save
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      end,
    },


    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    },

    {
      "akinsho/toggleterm.nvim",
      version = "*", -- Use latest stable version
      config = function()
        require("toggleterm").setup({
          size = 20,
          open_mapping = [[<C-\>]],
          direction = "float", -- Options: horizontal vertical flat tab
          shade_terminals = true,
          shading_factor = 2,
          close_on_exit = true,
          start_in_insert = true,
        })
      end,
    },

    --  {
    -- 		"kdheepak/lazygit.nvim",
    -- 		lazy = true,
    -- 		cmd = {
    -- 				"LazyGit",
    -- 				"LazyGitConfig",
    -- 				"LazyGitCurrentFile",
    -- 				"LazyGitFilter",
    -- 				"LazyGitFilterCurrentFile",
    -- 		},
    -- 		-- optional for floating window border decoration
    -- 		dependencies = {
    -- 				"nvim-lua/plenary.nvim",
    -- 		},
    -- 		-- setting the keybinding for LazyGit with 'keys' is recommended in
    -- 		-- order to load the plugin when the command is run for the first time
    -- 		keys = {
    -- 				{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    -- 		}
    -- },



    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup({
          signs                        = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
          },
          signs_staged                 = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
          },
          signs_staged_enable          = true,
          signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
          numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
          linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
          word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
          watch_gitdir                 = {
            follow_files = true
          },
          auto_attach                  = true,
          attach_to_untracked          = false,
          current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
          current_line_blame_opts      = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
            use_focus = true,
          },
          current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
          sign_priority                = 6,
          update_debounce              = 100,
          status_formatter             = nil,   -- Use default
          max_file_length              = 40000, -- Disable if file is longer than this (in lines)
          preview_config               = {
            -- Options passed to nvim_open_win
            border = 'single',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
          },

          -- on_attach = function(bufnr)
          -- 				local gs = require("gitsigns")
          -- 				local opts = { noremap = true, silent = true, buffer = bufnr }
          --
          -- 				-- Normal mode mappings
          -- 				vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
          -- 				vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
          -- 				vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
          -- 				vim.keymap.set("n", "<leader>hS", gs.stage_buffer, opts)
          -- 				vim.keymap.set("n", "<leader>hR", gs.reset_buffer, opts)
          -- 				-- vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
          -- 				vim.keymap.set("n", "<leader>hp", gs.preview_hunk_inline, opts)
          -- 				vim.keymap.set("n", "<leader>hnn", gs.next_hunk, opts)
          -- 				vim.keymap.set("n", "<leader>hnp", gs.prev_hunk, opts)
          -- 				vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
          -- 				vim.keymap.set("n", "<leader>td", gs.toggle_deleted, opts)
          --
          -- 				-- Visual mode mappings using the helper function
          -- 				vim.keymap.set("v", "<leader>hs", gitsigns_visual_op("stage_hunk"), opts)
          -- 				vim.keymap.set("v", "<leader>hr", gitsigns_visual_op("reset_hunk"), opts)
          -- 				vim.keymap.set("v", "<leader>hu", gitsigns_visual_op("undo_stage_hunk"), opts)
          --
          -- 				-- Optionally, if you have any additional text object mappings:
          -- 				vim.keymap.set("o", "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "[TextObj] Gitsigns: Inner hunk" })
          -- 				vim.keymap.set("x", "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "[TextObj] Gitsigns: Inner hunk" })
          -- 			end,
        })
      end,
    },

    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end
    },

    {
      "stevearc/oil.nvim",
      config = function()
        require("oil").setup({
          default_file_explorer = true, -- Make oil the default file explorer
          restore_win_options = true,   -- Restore window options when exiting Oil
          view_options = {
            show_hidden = true,         -- Show hidden files (e.g., .gitignore) by default
          },
          keymaps = {
            ["q"] = "actions.close",       -- Close oil window with 'q'
            ["<CR>"] = "actions.select",   -- Open file with Enter
            ["<C-l>"] = "actions.refresh", -- Refresh the oil view
          },
        })
      end,
    },


    -- {
    --       "kevinhwang91/nvim-ufo",
    --       dependencies = { "kevinhwang91/promise-async" },
    --       config = function()
    --           -- Basic configuration for nvim-ufo
    --           require("ufo").setup({
    --               provider_selector = function(bufnr, filetype, buftype)
    --                   return { "treesitter", "indent" }
    --               end,
    --           })
    --       end,
    --   },

    -- {
    --   "epwalsh/obsidian.nvim",
    --   version = "*",  -- recommended, use latest release instead of latest commit
    --   lazy = true,
    --   ft = "markdown",
    --   -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    --   -- event = {
    --   --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   --   -- refer to `:h file-pattern` for more examples
    --   --   "BufReadPre path/to/my-vault/*.md",
    --   --   "BufNewFile path/to/my-vault/*.md",
    --   -- },
    --   dependencies = {
    -- 	-- Required.
    -- 	"nvim-lua/plenary.nvim",
    --
    -- 	-- see below for full list of optional dependencies 👇
    --   },
    --   opts = {
    -- 	workspaces = {
    -- 	  {
    -- 		name = "personal",
    -- 		path = "~/vaults/personal",
    -- 	  },
    -- 	 --  {
    -- 		-- name = "work",
    -- 		-- path = "~/vaults/work",
    -- 	 --  },
    -- 	},
    --
    -- 	-- see below for full list of options 👇
    --   },
    -- },


    -- theme
    -- {
    -- 	"ellisonleao/gruvbox.nvim",
    -- 	priority = 1000,
    -- 	config = function()
    -- 		require("gruvbox").setup {
    -- 			contrast = "hard",
    -- 			transparent_mode = false,
    -- 		}
    -- 		vim.cmd("colorscheme gruvbox")
    -- 	end
    -- },
    --
    -- {
    -- 		"rose-pine/neovim",
    -- 		name = "rose-pine",
    -- 		priority = 1000,
    -- 		config = function()
    -- 			vim.cmd("colorscheme rose-pine")
    -- 		end
    -- },

    -- {
    -- 	"navarasu/onedark.nvim",
    -- 	name = "onedark",
    -- 	priority = 1000,
    -- 	config = function()
    -- 		require("onedark").setup({
    -- 			style = "warmer"
    -- 		})
    -- 		vim.cmd("colorscheme onedark")
    -- 	end
    -- },

    -- {
    --   "olimorris/onedarkpro.nvim",
    -- 		config = function()
    -- 			vim.cmd("colorscheme onedark_dark")
    -- 		end
    -- },

    {
      'ribru17/bamboo.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        require('bamboo').setup {
          -- optional configuration here
          style = 'multiplex',                          -- the greener one
          toggle_style_key = '<leader>ts',
          toggle_style_list = { 'multiplex', 'light' }, -- List of styles to toggle between
        }
        require('bamboo').load()
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#707070" }) -- or "#aaaaaa", etc.
      end,
    },

    {
      'eandrju/cellular-automaton.nvim'
    },

    -- {
    -- 	'psliwka/vim-smoothie'
    -- },

    -- LLM
    {
      "zbirenbaum/copilot.lua",
      config = function()
        require("copilot").setup({
          panel = { enabled = false },
          suggestion = {
            enabled = true,
            auto_trigger = false,
            manual_trigger = true,
            hide_during_completion = true,
            debounce = 75,
            virtual_text = true,
          },
        })
      end
    },

    -- Copilot chat
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "canary",
      dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim" },

      },
      build = "make tiktoken",
      opts = {
        debug = true,
      },
      cmd = { "CopilotChat" },
    },

    {
      'mfussenegger/nvim-dap',
      dependencies = {
        -- Recommended: A UI for nvim-dap
        'rcarriga/nvim-dap-ui',
        -- Recommended: To easily install debug adapters
        'nvim-neotest/nvim-nio',   -- Dependency for dap-ui
        'jay-babu/mason-nvim-dap.nvim',
        'williamboman/mason.nvim', -- Mason is needed for mason-nvim-dap
      },
      config = function()
        local dap = require('dap')
        local dapui = require('dapui')
        local mason_dap = require('mason-nvim-dap')

        -- Set up mason-nvim-dap for easy adapter installation
        mason_dap.setup({
          -- List of debug adapters to automatically install
          ensure_installed = {
            -- Add debuggers for the languages you use, e.g.,
            -- "python",
            -- "codelldb", -- for C/C++/Rust
            -- "js-debug", -- for JavaScript/TypeScript
            "codelldb",
          },
        })

        -- Basic DAP UI configuration
        dapui.setup({
          -- your preferred UI configuration options
          elements = {
            'scopes',
            'breakpoints',
            'stacks',
            'watches',
          },
          controls = {
            element = "controls",
            enabled = true,
            icons = {
              continue = "▶",
              pause = "⏸",
              terminate = "⏹",
            },
          },
          layouts = {
            {
              elements = {
                -- Array of elements to display in their own windows.
                { element = "scopes",      size = 0.25 },
                { element = "breakpoints", size = 0.25 },
                { element = "stacks",      size = 0.25 },
                { element = "watches",     size = 0.25 },
              },
              size = 80,          -- Size of the floating windows
              position = "right", -- Position of the floating windows
            },
          },
        })

        -- Auto-open DAP UI when a session starts and close when it ends
        dap.listeners.before.attach.dapui_config = function()
          dapui.open({})
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close({})
        end

        -- You will need to add language-specific configurations here
        -- Examples:
        -- dap.configurations.python = { ... }
        dap.configurations.cpp = {
              name = "Launch file",
              type = "codelldb",
              request = "launch",
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              cwd = '${workspaceFolder}',
              stopOnEntry = false,
            },
            -- }
            -- dap.configurations.javascript = { ... }
            -- Refer to the nvim-dap wiki or mason-nvim-dap documentation for specific language setups.

            -- Basic keymaps (highly recommended)
            vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'DAP: Continue' })
        vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'DAP: Step Over' })
        vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'DAP: Step Into' })
        vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'DAP: Step Out' })
        vim.keymap.set('n', '<Leader>B', function() dap.toggle_breakpoint() end, { desc = 'DAP: Toggle Breakpoint' })
        -- vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        -- { desc = 'DAP: Set Conditional Breakpoint' })
        vim.keymap.set('n', '<Leader>lp',
          function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
          { desc = 'DAP: Set Logpoint' })
        vim.keymap.set('n', '<Leader>dr', function() dap.repl.toggle() end, { desc = 'DAP: Toggle REPL' })
        vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = 'DAP: Run Last' })
        vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
          require('dap.ui.widgets').hover()
        end, { desc = 'DAP: Hover Variables' })
        vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
          require('dap.ui.widgets').preview()
        end, { desc = 'DAP: Preview Variables' })
        vim.keymap.set('n', '<Leader>df', function()
          require('dap.ui.widgets').float_frame()
        end, { desc = 'DAP: Float Frame' })
        vim.keymap.set('n', '<Leader>ds', function()
          require('dap.ui.widgets').scopes()
        end, { desc = 'DAP: Scopes' })
      end
    },

    --	{
    --		"christoomey/vim-tmux-navigator",
    --		cmd = {
    --			"TmuxNavigateLeft",
    --			"TmuxNavigateDown",
    --			"TmuxNavigateUp",
    --			"TmuxNavigateRight",
    --			"TmuxNavigatePrevious",
    --			"TmuxNavigatorProcessList",
    --		},
    --		keys = {
    --			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    --			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    --			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    --			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    --			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    --		},
    --	},

    {
      "mrjones2014/smart-splits.nvim",
      -- works for nvim splits without tmux too
      enabled = true,
      config = function()
        require("smart-splits").setup({
          vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left),
          vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down),
          vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up),
          vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right),
          -- moving between splits
          vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left),
          vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down),
          vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up),
          vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right),
          -- vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous),
          -- swapping buffers between windows
          -- vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left),
          -- vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down),
          -- vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up),
          -- vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right),


        })
      end,
    },

    {
      'kana/vim-textobj-user', -- Dependency for vim-textobj-underscore
      lazy = true,             -- Load only when needed
    },
    {
      'lucapette/vim-textobj-underscore',
      dependencies = { 'kana/vim-textobj-user' },                  -- Explicitly state the dependency
      ft = { 'python', 'ruby', 'c', 'cpp', 'rust', 'lua', 'vim' }, -- Example: Only load for these filetypes
    },



    {
      "theprimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("harpoon"):setup()
      end,
      keys = {
        { "<leader>A", function() require("harpoon"):list():add() end,                                    desc = "harpoon file", },
        -- { "<leader>a", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "harpoon quick menu", },
        { "<leader>a", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "harpoon quick menu", },
        { "<leader>1", function() require("harpoon"):list():select(1) end,                                desc = "harpoon to file 1", },
        { "<leader>2", function() require("harpoon"):list():select(2) end,                                desc = "harpoon to file 2", },
        { "<leader>3", function() require("harpoon"):list():select(3) end,                                desc = "harpoon to file 3", },
        { "<leader>4", function() require("harpoon"):list():select(4) end,                                desc = "harpoon to file 4", },
        { "<leader>5", function() require("harpoon"):list():select(5) end,                                desc = "harpoon to file 5", },
        { "<leader>6", function() require("harpoon"):list():select(6) end,                                desc = "harpoon to file 6", },
        { "<leader>7", function() require("harpoon"):list():select(7) end,                                desc = "harpoon to file 7", },
        { "<leader>8", function() require("harpoon"):list():select(8) end,                                desc = "harpoon to file 8", },
        { "<leader>9", function() require("harpoon"):list():select(9) end,                                desc = "harpoon to file 9", },
        { "<leader>0", function() require("harpoon"):list():select(0) end,                                desc = "harpoon to file 0", },
      },
    },


    -- {
    --
    --
    -- 	-- Add the plugin
    -- 	'cenk1cenk2/tmux-toggle-popup.nvim',
    -- 	-- Recommended dependency for better integration
    -- 	dependencies = {
    -- 		'nvim-lua/plenary.nvim', -- Required for some utility functions
    -- 	},
    -- 	-- Configure the plugin
    -- 	config = function()
    -- 		require('tmux-toggle-popup').setup({
    -- 			-- You can add options here if needed.
    -- 			-- Check the plugin's GitHub page for available options.
    -- 			-- For example, you might configure the height or width of the popup.
    -- 			-- Default options are usually sensible, so starting with an empty setup() is fine.
    -- 			-- width = 80,
    -- 			-- height = 25,
    -- 			-- direction = 'top' -- or 'bottom'
    -- 		})
    --
    -- 		-- Set up a keybinding to toggle the tmux popup
    -- 		-- You can change '<C-t>' to any key combination you prefer.
    -- 		vim.keymap.set('n', '<C-t>', '<cmd>lua require("tmux-toggle").toggle()<CR>', { noremap = true, silent = true })
    -- 		vim.keymap.set('t', '<C-t>', '<cmd>lua require("tmux-toggle").toggle()<CR>', { noremap = true, silent = true })
    --
    -- 	end
    -- },
    --
    --
    {
      'nvim-lualine/lualine.nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons',
        'kiennt63/harpoon-files.nvim',
      },

      config = function()

        -- Define the custom function to display filename and faded path
        local function filename_with_faded_path()
          local filename = vim.fn.fnamemodify(vim.fn.bufname(), ":t") -- Get only the filename
          local full_path = vim.fn.fnamemodify(vim.fn.bufname(), ":p") -- Get the full path
          local current_dir = vim.fn.getcwd() .. "/"

          -- Remove the current working directory from the full path
          -- This makes the path relative to the current working directory, which is often more useful
          local relative_path = string.gsub(full_path, "^" .. current_dir, "", 1)

          -- If the file is in the current directory, relative_path will be the filename itself.
          -- We only want to show the path if it's not just the filename.
          local path_to_display = ""
          if relative_path ~= filename then
            -- Remove the filename from the relative path to get just the directory part
            path_to_display = string.gsub(relative_path, filename .. "$", "", 1)
            -- Remove trailing slash if it's not the root of the relative path
            if #path_to_display > 0 and path_to_display:sub(-1) == '/' then
              path_to_display = path_to_display:sub(1, -2)
            end
            path_to_display = " (" .. path_to_display .. ")"
          end
          
          -- Format the output with highlight groups
          return {
            { filename, highlight = "LualineNormal" }, -- Or default 'Lualine_c_normal'
            { path_to_display, highlight = "LualineFadedPath" }
          }
        end




        require('lualine').setup {
          options = {
            icons_enabled = true,
            theme = 'auto',
            -- component_separators = { left = '', right = '' },
            -- section_separators = { left = '', right = '' },
            disabled_filetypes = {
              statusline = {},
              -- winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
              statusline = 100,
              tabline = 100,
              winbar = 100,
            }
          },
          sections = {
            lualine_a = { 'mode' },
            -- lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_b = { 'branch' },
            lualine_c = { 
              {'filename', 
                path=0
              },
              -- {'filename', 
              --   path=3
              -- }
                        },
            -- lualine_c = {require('harpoon_files').lualine_component},
            -- lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_x = { 'lsp_status' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
          },
          tabline = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { require('harpoon_files').lualine_component },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
          },
          winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 
              { 'filename',
              path = 3
              }
            },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
          },
          inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 
              { 'filename',
              path = 3
              }
            },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
          },
          extensions = {}
        }
      end,
    }, --
    {
      'kiennt63/harpoon-files.nvim',
      dependencies = {
        { 'ThePrimeagen/harpoon' },
      },
      opts = {
        max_length = 50,
        -- icon = '',
        show_icon = false,
        show_index = true,
        show_filename = true,
        separator_left = ' ',
        separator_right = ' '
      },
    },

    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      config = function()
        -- Define the highlight for scope underline
        vim.api.nvim_set_hl(0, "IndentBlanklineScope", {
          underline = true,
          sp = "#61AFEF", -- soft blue, adjust if needed
        })

        vim.api.nvim_set_hl(0, "IblIndent", {
          fg = "#3a3a3a", -- dim grey for all indent lines
        })

        vim.api.nvim_set_hl(0, "IblScope", {
          fg = "#5a5a5a", -- slightly lighter grey for scope line
          -- bold = true, -- optional: remove for full subtlety
        })

        require("ibl").setup({
          indent = {
            char = "┊", -- or "┊" for even softer feel
            highlight = "IblIndent",
          },
          scope = {
            enabled = true,
            show_start = false,
            show_end = false,
            highlight = "IblScope",
          },
        })
      end,
    },


    {
      'HiPhish/rainbow-delimiters.nvim',
      config = function()
        -- Use default rainbow-delimiters colors (don’t override)
        require('rainbow-delimiters.setup').setup({
          strategy = {
            [''] = 'rainbow-delimiters.strategy.global',
            vim = 'rainbow-delimiters.strategy.local',
          },
          query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
          },
          priority = {
            [''] = 110,
            lua = 210,
          },
          -- no highlight override here to keep defaults
        })
      end,
    },

    {
      "ojroques/nvim-osc52",
      config = function()
        require("osc52").setup {
          max_length = 0, -- Maximum length of selection (0 for no limit)
          silent = false, -- Disable message on successful copy
          trim = false, -- Trim surrounding whitespaces before copy
        }
        local function copy()
          if ((vim.v.event.operator == "y" or vim.v.event.operator == "d")
                and vim.v.event.regname == "") then
            require("osc52").copy_register("")
          end
        end

        vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })
      end,
    },

    {
        'MeanderingProgrammer/render-markdown.nvim',
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        -- -@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

{
  'bullets-vim/bullets.vim',
  ft = { 'markdown' },
  init = function()
    vim.g.bullets_enabled_file_types = { 'markdown' }
  end,
},

  }, --[[ end of plugin list ]]

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "onedark" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false }, -- Notify = false so it doesnt bother me at every startup
})
