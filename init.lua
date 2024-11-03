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



--- General settings


-- disable netrw file explorer in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


vim.api.nvim_set_option("clipboard","unnamed") -- Merge nvim and macos clipboards
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { noremap = true, silent = true })

-- Toggle comment for the current line
vim.keymap.set("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { noremap = true, silent = true })

-- Toggle comment for a visual selection
vim.keymap.set("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { noremap = true, silent = true })


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

--- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
	

	-- file explorer
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {}
		end,
	},
 


	-- Syntax tree: more advanced syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
				indent = { enable = true },
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
				}
			})
		end
	},

	-- LSP configuration (LSP scans codebase and lines declarations w/ implementaitions, does some syntax highlighting)
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.pyright.setup({})

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
					direction = "horizontal", -- Options: horizontal vertical flat tab
					shade_terminals = true,
					shading_factor = 2,
					close_on_exit = true,
					start_in_insert = true,
				})
			end,
	},


	-- theme
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup {
				contrast = "hard",
				transparent_mode = false,
			}
			vim.cmd("colorscheme gruvbox")
		end
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

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "onedark" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false }, -- Notify = false so it doesnt bother me at every startup
})
