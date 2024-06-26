if not vim.g.vscode then
	local opt = vim.opt
	opt.tabstop = 4
	opt.expandtab = true
	opt.shiftwidth = 4
	opt.smartindent = true
	opt.relativenumber = true
    opt.cmdheight = 0

	function Open_cheatsheet()
		local che = vim.fn.stdpath("config") .. "/cheatsheet.md"
		vim.cmd("split " .. che)
		vim.cmd("setlocal readonly")
		vim.cmd("resize 10")
	end

	-- keymaps.
	vim.keymap.set("n", "[b", ":bprev<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<C-j>", ":bprev<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<C-k>", ":bnext<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<C-p>", ":FzfLua files<CR>", { noremap = true })
	vim.keymap.set("n", "<leader>cs", "<cmd>lua Open_cheatsheet()<CR>", { noremap = true, silent = true })

	vim.keymap.set("t", "<A-j>", "<C-\\><C-n><C-w>w", { noremap = true, silent = true })

	local undodir = vim.fn.stdpath("config") .. "/undo"
	if vim.fn.isdirectory(undodir) == 0 then
		vim.fn.mkdir(undodir, "p")
	end
	vim.opt.undodir = undodir
	vim.opt.undofile = true

	-- manage plugins.
	vim.cmd.packadd("packer.nvim")
	require("packer").startup(function()
		use("wbthomason/packer.nvim")
		-- use("rstacruz/vim-closer")
		use("cohama/lexima.vim")
		use("ibhagwan/fzf-lua")
		use({
			"neovim/nvim-lspconfig",
			config = function()
				local status_ok, lspconfig = pcall(require, "lspconfig")
				if not status_ok then
					print("lspconfig is not installed")
					return
				end

				-- Start Language server.

				-- Lua.
				if lspconfig.lua_ls then
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = {
										"vim",
									},
								},
							},
						},
					})
				end

				-- TypeScript.
				if lspconfig.tsserver then
					lspconfig.tsserver.setup({})
				end

				-- OCaml.
				if lspconfig.ocamllsp then
					lspconfig.ocamllsp.setup({})
				end

				-- Go.
				if lspconfig.gopls then
					lspconfig.gopls.setup({})
				end

				if lspconfig.terraformls then
					lspconfig.terraformls.setup({})
				end

				-- Lsp Keymaps.
				-- global.
				vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
				vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

				-- after the language server attaches to the current buffer
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("UserLspConfig", {}),
					callback = function(ev)
						vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

						local opts = { buffer = ev.buf }
						vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
						vim.keymap.set("n", "<space>k", vim.lsp.buf.hover, opts)
						vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
						vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					end,
				})
			end,
		})
		use({
			"nvimtools/none-ls.nvim",
			requires = { { "nvim-lua/plenary.nvim" } },
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						null_ls.builtins.formatting.ocamlformat.with({
							cwd = function(params)
								conf = vim.fn.findfile(".ocamlformat", params.root)
								if conf then
									return vim.fn.fnamemodify(conf, ":p:h")
								end
							end,
						}),
						null_ls.builtins.formatting.stylua,
						null_ls.builtins.formatting.gofmt,
						null_ls.builtins.formatting.goimports,
					},
					on_attach = function(_, bufnr)
						vim.keymap.set("n", "<space>f", function()
							vim.lsp.buf.format({
								async = true,
								filter = function(client)
									return client.name == "null-ls"
								end,
							})
						end, { buffer = bufnr })
					end,
				})
			end,
		})

		-- Lsp Complement.
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/nvim-cmp")
		use("L3MON4D3/LuaSnip")
		use("saadparwaiz1/cmp_luasnip")

		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}),
			{ name = "buffer" },
		})
	end)
end

local keymap = vim.keymap
keymap.set("i", "jj", "<ESC>")
keymap.set("n", "<leader>nh", ":nohl<CR>")

keymap.set("n", "<S-k>", "10<UP>")
keymap.set("n", "<S-j>", "10<DOWN>")
keymap.set("n", "<S-h>", "10<LEFT>")
keymap.set("n", "<S-l>", "10<RIGHT>")

keymap.set("v", "<S-k>", "10<UP>")
keymap.set("v", "<S-j>", "10<DOWN>")
keymap.set("v", "<S-h>", "10<LEFT>")
keymap.set("v", "<S-l>", "10<RIGHT>")

vim.opt.clipboard:append("unnamedplus")
