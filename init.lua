-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

--- Set up leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\" -- todo: understand this
vim.opt.guifont = "JetBrainsMono Nerd Font:h14" -- Adjust the size (h14)

--- General settings

-- disable netrw file explorer in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim-smoothie linear scroll
vim.g.smoothie_exponential_factor = 1.0


vim.api.nvim_set_option("clipboard","unnamedplus") -- Merge nvim and linux clipboards
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })


vim.keymap.set("n", "<leader>sh", ":ClangdSwitchSourceHeader<CR>", { noremap = true, silent = true, desc = "Switch between source and header" })

vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })  -- List open buffers
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { noremap = true, silent = true }) -- List recent files

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, silent = true, desc = "Open Oil file explorer" })

-- Toggle comment for the current line
vim.keymap.set("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { noremap = true, silent = true })

-- Toggle comment for a visual selection
vim.keymap.set("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { noremap = true, silent = true })

-- gitsigns stuff
vim.keymap.set("n", "<leader>sh", function() require("gitsigns").stage_hunk() end, { noremap = true, silent = true, desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>ush", function() require("gitsigns").undo_stage_hunk() end, { noremap = true, silent = true, desc = "Undo Stage Hunk" })
vim.keymap.set("n", "<leader>rh", function() require("gitsigns").reset_hunk() end, { noremap = true, silent = true, desc = "Reset Hunk" })
vim.keymap.set("v", "<leader>sh", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { noremap = true, silent = true, desc = "Stage Hunk (Visual)" })
vim.keymap.set("v", "<leader>ush", function() require("gitsigns").undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { noremap = true, silent = true, desc = "Stage Hunk (Visual)" })
vim.keymap.set("v", "<leader>rh", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { noremap = true, silent = true, desc = "Reset Hunk (Visual)" })
-- vim.keymap.set("n", "<leader>gsS", function() require("gitsigns").stage_buffer() end, { noremap = true, silent = true, desc = "Stage Buffer" })
-- vim.keymap.set("n", "<leader>ush", function() require("gitsigns").undo_stage_hunk() end, { noremap = true, silent = true, desc = "Undo Stage Hunk" })
-- vim.keymap.set("n", "<leader>gsR", function() require("gitsigns").reset_buffer() end, { noremap = true, silent = true, desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>hp", function() require("gitsigns").preview_hunk_inline() end, { noremap = true, silent = true, desc = "Preview Hunk Inline" })
vim.keymap.set("n", "<leader>nh", function() require("gitsigns").next_hunk() end, { noremap = true, silent = true, desc = "Next Hunk" })
vim.keymap.set("n", "<leader>ph", function() require("gitsigns").prev_hunk() end, { noremap = true, silent = true, desc = "Prev Hunk" })
-- vim.keymap.set("n", "<leader>gsb", function() require("gitsigns").blame_line({ full = true }) end, { noremap = true, silent = true, desc = "Blame Line (Full)" })
vim.keymap.set("n", "<leader>tb", function() require("gitsigns").toggle_current_line_blame() end, { noremap = true, silent = true, desc = "Toggle Current Line Blame" })
-- vim.keymap.set("n", "<leader>gsd", function() require("gitsigns").diffthis() end, { noremap = true, silent = true, desc = "Diff This" })
-- vim.keymap.set("n", "<leader>gsD", function() require("gitsigns").diffthis("~") end, { noremap = true, silent = true, desc = "Diff This (~)" })

-- -- folding
-- vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, { noremap = true, silent = true, desc = "Open All Folds" })
-- vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, { noremap = true, silent = true, desc = "Close All Folds" })
-- vim.keymap.set("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { noremap = true, silent = true, desc = "Open Fold Levels" })
-- vim.keymap.set("n", "zm", function() require("ufo").closeFoldsWith() end, { noremap = true, silent = true, desc = "Close Fold Levels" })

vim.keymap.set("n", "<leader>td", function() require("gitsigns").toggle_deleted() end, { noremap = true, silent = true, desc = "Toggle Deleted" })

-- How much to 'conceal' formatting characters in, for example, .md files. 0, 1, or 2
vim.opt.conceallevel = 1


-- Cellular automation
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")


-- folding
vim.o.foldcolumn = "1"      -- Show fold column
vim.o.foldlevel = 99        -- Set a high fold level to keep folds open by default
vim.o.foldlevelstart = 99   -- Start with all folds open
vim.o.foldenable = true     -- Enable folding

-- Copilot: <leader><Tab> normal mode to toggle, <Tab> insert mode to accept
local function toggle_copilot_auto_trigger()
	local copilot = require("copilot.suggestion")
	-- Toggle auto-trigger
	copilot.toggle_auto_trigger()
	vim.notify("copilot toggled", vim.log.levels.INFO, { title = "Copilot" })
end
vim.keymap.set("n", "<leader><Tab>", toggle_copilot_auto_trigger, { noremap = true, silent = true})
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






-- copilot chat
vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChat<CR>", { noremap = true, silent = true })

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 4,       -- Space between code and virtual text
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
        source = "always",  -- Show the source of the diagnostic in floating windows
		severity_sort = true,
    },
    signs = true,  -- Show diagnostic signs in the sign column
    underline = true,  -- Underline diagnostics in the code
    update_in_insert = false,  -- Update diagnostics only after leaving insert mode
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
		{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
		{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
		{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
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
						additional_vim_regex_highlighting = false,
					},
				indent = { enable = true },
				ensure_installed = { "lua", "cpp", "python", "markdown" },
			})
		end
	},



	-- Fuzzy finder (for files and words)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					path_display = {'filename_first'},
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
            '--no-ignore'  -- Add this line to ignore .gitignore
        }
				},
				  extensions = {
					fzf = {
					  fuzzy = true,                    -- false will only do exact matching
					  override_generic_sorter = true,  -- override the generic sorter
					  override_file_sorter = true,     -- override the file sorter
					  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
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
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
	},

	-- LSP configuration (LSP scans codebase and lines declarations w/ implementaitions, does some syntax highlighting)
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
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
						extraPaths = { "ros_utilities" }
						}
						}
					}
				})

			-- Prevent err "multiple client offset encodings" conflict b/w clangd and copilot
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.offsetEncoding = { "utf-16" }
			lspconfig.clangd.setup({
				cmd = { "clangd", "--clang-tidy=false" }, -- disable built in clang-tidy, as i installed it separately
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
					vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, bufopts)

					-- -- format on save	
					-- vim.api.nvim_create_autocmd("BufWritePre", {
					-- 	buffer = bufnr,
					-- 	callback = function()
					-- 		vim.lsp.buf.format({ async = true })
					-- 	end,
					-- })

				end,

				settings = {
					clangd = {
						compilationDatabasePath = "build" 
						-- where compile_commands.json is stored for more complex codebases 
						-- (where clangd's automatic inferral may not be sufficient)
					},
				},

			})
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

	 {
			"kdheepak/lazygit.nvim",
			lazy = true,
			cmd = {
					"LazyGit",
					"LazyGitConfig",
					"LazyGitCurrentFile",
					"LazyGitFilter",
					"LazyGitFilterCurrentFile",
			},
			-- optional for floating window border decoration
			dependencies = {
					"nvim-lua/plenary.nvim",
			},
			-- setting the keybinding for LazyGit with 'keys' is recommended in
			-- order to load the plugin when the command is run for the first time
			keys = {
					{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
			}
	},



	{
			"lewis6991/gitsigns.nvim",
			config = function()
					require("gitsigns").setup({
						 signs = {
								add          = { text = '┃' },
								change       = { text = '┃' },
								delete       = { text = '_' },
								topdelete    = { text = '‾' },
								changedelete = { text = '~' },
								untracked    = { text = '┆' },
							},
							signs_staged = {
								add          = { text = '┃' },
								change       = { text = '┃' },
								delete       = { text = '_' },
								topdelete    = { text = '‾' },
								changedelete = { text = '~' },
								untracked    = { text = '┆' },
							},
							signs_staged_enable = true,
							signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
							numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
							linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
							word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
							watch_gitdir = {
								follow_files = true
							},
							auto_attach = true,
							attach_to_untracked = false,
							current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
							current_line_blame_opts = {
								virt_text = true,
								virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
								delay = 1000,
								ignore_whitespace = false,
								virt_text_priority = 100,
								use_focus = true,
							},
							current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
							sign_priority = 6,
							update_debounce = 100,
							status_formatter = nil, -- Use default
							max_file_length = 40000, -- Disable if file is longer than this (in lines)
							preview_config = {
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
				default_file_explorer = true,    -- Make oil the default file explorer
				restore_win_options = true,      -- Restore window options when exiting Oil
				view_options = {
					show_hidden = true,          -- Show hidden files (e.g., .gitignore) by default
				},
				keymaps = {
					["q"] = "actions.close",     -- Close oil window with 'q'
					["<CR>"] = "actions.select", -- Open file with Enter
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
				style = 'multiplex', -- the greener one
				toggle_style_key = '<leader>ts',
				toggle_style_list = {'multiplex', 'light' }, -- List of styles to toggle between
			}
			require('bamboo').load()
		end,
	},

	{
		'eandrju/cellular-automaton.nvim' 
	},

	{
		'psliwka/vim-smoothie'
	},

	-- LLM
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				panel = {enabled = false },
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

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "onedark" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false }, -- Notify = false so it doesnt bother me at every startup
})
