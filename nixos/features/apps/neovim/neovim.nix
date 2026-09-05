{inputs, ...}: {
  flake.nixosModules.neovim = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.nvf.nixosModules.default
    ];

    programs.nvf = {
      enable = true;

      # Whether to set `nvf` as the default editor.
      # This will set the `EDITOR` environment variable as `nvim` if set to true.
      defaultEditor = true;

      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;

          extraPackages = [pkgs.gnumake pkgs.gcc];

          # Set the case sensitivity of search
          searchCase = "smart";

          undoFile.enable = true;

          # vim.opts and vim.options are aliased
          opts = {
            shiftwidth = 2;
            tabstop = 2;
            expandtab = true;
            autoindent = true;
            updatetime = 200;

            # Smart word wrap
            wrap = true;
            linebreak = true;
            breakindent = true;

            # Autosave
            autowriteall = true;

            # Quality of life
            scrolloff = 8;
            sidescrolloff = 8;
            signcolumn = "yes";
          };

          spellcheck = {
            enable = true;
            extraSpellWords."en.utf-8" =
              lib.filter (w: w != "") (lib.splitString "\n" (builtins.readFile ./spell-words.txt));
          };

          lsp = {
            # This must be enabled for the language modules to hook into
            # the LSP API.
            enable = true;

            formatOnSave = true;
            inlayHints.enable = true;
            lightbulb.enable = true;
            trouble.enable = true;
            lspSignature.enable = true; # safe with nvim-cmp
            presets.tailwindcss-language-server.enable = true;
            otter-nvim.enable = true;

            # -fqbn: Fully qualified board name to use initially (can be
            # changed via JSON-RPC). Defaults to arduino:avr:uno.
            # https://github.com/arduino/arduino-language-server
            servers.arduino-language-server.cmd = lib.mkForce [
              (lib.getExe pkgs.arduino-language-server)
              "-clangd"
              (lib.getExe' pkgs.clang-tools "clangd")
              "-cli"
              (lib.getExe pkgs.arduino-cli)
              "-cli-config"
              "$HOME/.arduino15/arduino-cli.yaml"
              "-fqbn"
              "adafruit:samd:adafruit_feather_m0"
            ];

            # :h R-language-server
            servers.r-languageserver.cmd_env.R_PROFILE_USER = toString (pkgs.writeText "Rprofile" ''
              options(
                  languageserver.server_capabilities = list(
                      hoverProvider = FALSE,
                      signatureHelpProvider = FALSE,
                      completionProvider = FALSE,
                      completionItemResolve = FALSE,
                      definitionProvider = FALSE,
                      referencesProvider = FALSE,
                      implementationProvider = FALSE,
                      documentHighlightProvider = FALSE,
                      documentSymbolProvider = FALSE,
                      workspaceSymbolProvider = FALSE,
                      renameProvider = FALSE
                  )
              )
            '');

            # nvim-lspconfig, also enabled automatically
            lspconfig.enable = true;
            lspconfig.sources.ltex = ''
              vim.lsp.config('ltex', {
                cmd = {"${lib.getExe pkgs.ltex-ls}"},
                handlers = {
                  ["$/progress"] = function() end,
                  ["window/workDoneProgress/create"] = function() return vim.NIL end,
                },
                settings = {
                  ltex = {
                    language = "en-US",
                  },
                },
              })
              vim.lsp.enable('ltex')
            '';
          };

          debugger = {
            nvim-dap = {
              enable = true;
              ui.enable = true;
            };
          };

          # This section does not include a comprehensive list of available language modules.
          # To list all available language module options, please visit the nvf manual.
          languages = {
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;

            # Languages that will be supported in default and maximal configurations.
            nix.enable = true;
            markdown = {
              enable = true;
              extensions.render-markdown-nvim = {
                enable = true;
                setupOpts = {
                  latex.enabled = false;
                };
              };
            };

            # Languages that are enabled in the maximal configuration.
            bash.enable = true;
            css.enable = true;
            html.enable = true;
            json.enable = true;
            yaml.enable = true;
            lua.enable = true;
            python.enable = true;
            typescript.enable = true;
            tex.enable = true;

            # Language modules that are not as common.
            arduino.enable = true;
            r = {
              enable = true;
              format.enable = false;
            };
            typst.enable = true;
          };

          visuals = {
            nvim-scrollbar.enable = true;
            nvim-web-devicons.enable = true;
            cinnamon-nvim.enable = true;
            fidget-nvim.enable = true;

            highlight-undo.enable = true;
            indent-blankline = {
              enable = true;
              setupOpts.exclude.filetypes = [
                "dashboard"
                "alpha"
                "neo-tree"
              ];
            };
          };

          statusline = {
            lualine = {
              enable = true;
              integrations.breadcrumbs.navbuddy.enable = true;
              setupOpts = {
                sections = {
                  lualine_z = {};
                };
              };
            };
          };

          autopairs.nvim-autopairs.enable = true;

          # nvf provides various autocomplete options. The tried and tested nvim-cmp
          # is enabled in default package, because it does not trigger a build. We
          # enable blink-cmp in maximal because it needs to build its rust fuzzy
          # matcher library.
          autocomplete = {
            nvim-cmp.enable = true;
          };

          snippets.luasnip.enable = true;

          filetree = {
            neo-tree = {
              enable = true;
            };
          };

          tabline = {
            nvimBufferline = {
              enable = true;
              mappings = {
                closeCurrent = "<leader>bd";
              };
            };
          };

          treesitter = {
            context.enable = true;
            textobjects.enable = true;
          };

          binds = {
            whichKey.enable = true;
            cheatsheet.enable = true;
          };

          telescope.enable = true;

          git = {
            enable = true;
            git-conflict.enable = false;
            hunk-nvim.enable = false;
            vim-fugitive.enable = false;
          };

          dashboard = {
            dashboard-nvim.enable = true;
          };

          notify = {
            nvim-notify = {
              enable = true;
              setupOpts.background_colour = "Normal";
            };
          };

          projects = {
            project-nvim.enable = true;
          };

          utility = {
            direnv.enable = true;
            multicursors.enable = true;
            diffview-nvim.enable = true;
            surround.enable = true;
            smart-splits.enable = true;
            undotree.enable = true;

            motion = {
              flash-nvim.enable = true;
            };
          };

          notes = {
            todo-comments.enable = true;
          };

          terminal = {
            toggleterm = {
              enable = true;
              lazygit.enable = true;
              setupOpts.shade_terminals = false;
            };
          };

          ui = {
            borders.enable = true;
            noice.enable = true;
            colorizer.enable = true;
            illuminate.enable = true;
            smartcolumn.enable = false;
            fastaction.enable = true;
          };

          assistant = {
            copilot = {
              enable = true;
              cmp.enable = false;
            };
          };

          session = {
            nvim-session-manager = {
              enable = true;
              setupOpts.autoload_mode = "CurrentDir";
            };
          };

          comments = {
            comment-nvim.enable = true;
          };

          clipboard = {
            enable = true;
            registers = "unnamedplus";
            providers.wl-copy.enable = true;
          };

          keymaps = [
            {
              key = "<leader>e";
              mode = ["n"];
              action = "<cmd>Neotree toggle<CR>";
              silent = true;
              desc = "Toggle Neo-tree";
            }
            {
              key = "<leader>w";
              mode = ["n"];
              action = "<cmd>w<CR>";
              silent = true;
              desc = "Save File";
            }
            {
              key = "<leader>q";
              mode = ["n"];
              action = "<cmd>qa<CR>";
              silent = true;
              desc = "Quit All";
            }
            {
              key = "<Esc>";
              mode = ["n"];
              action = "<cmd>nohlsearch<CR><Esc>";
              silent = true;
              desc = "Clear Search Highlights";
            }
            {
              key = "<leader>|";
              mode = ["n"];
              action = "<cmd>vsplit<CR>";
              silent = true;
              desc = "Split Window Vertically";
            }
            {
              key = "<leader>-";
              mode = ["n"];
              action = "<cmd>split<CR>";
              silent = true;
              desc = "Split Window Horizontally";
            }
            {
              key = "<";
              mode = ["v"];
              action = "<gv";
              silent = true;
              desc = "Indent Left (Keep Selection)";
            }
            {
              key = ">";
              mode = ["v"];
              action = ">gv";
              silent = true;
              desc = "Indent Right (Keep Selection)";
            }
            {
              key = "<leader>tp";
              mode = ["n"];
              action = "<cmd>TypstPreview<CR>";
              silent = true;
              desc = "Start Typst Preview";
            }
          ];

          autocmds = [
            {
              event = ["FocusLost"];
              pattern = ["*"];
              command = "silent! wa";
            }
          ];

          extraPlugins = with pkgs.vimPlugins; {
            "vimtex" = {
              package = vimtex;
              setup = ''
                vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
                vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
                vim.g.vimtex_quickfix_open_on_warning = 0
              '';
            };
            "typst-preview.nvim" = {
              package = typst-preview-nvim;
              setup = "require('typst-preview').setup()";
            };
            "R.nvim" = {
              package = pkgs.vimPlugins.R-nvim.overrideAttrs {
                buildPhase = "make -C rnvimserver";
              };
              setup = ''
                if vim.fn.executable("R") == 1 then
                  require("r").setup()
                else
                  vim.g.R_filetypes = {}
                end
              '';
            };
          };
        };
      };
    };
  };
}
