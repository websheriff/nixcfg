{ inputs, pkgs, ... }:
let
  keymaps = import ./keymaps.nix;
in
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  stylix.targets.nvf.enable = false;

  programs.nvf = {
    enable = true;
    defaultEditor = true;
    enableManpages = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        globals.mapleader = " ";

        options = {
          # general settings
          clipboard = "unnamedplus";
          mouse = "a";
          splitbelow = true;
          splitright = true;
          termguicolors = true;
          completeopt = "menuone,noselect";

          # tab settings
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
          expandtab = true;
          shiftround = true;
          autoindent = true;
          smartindent = true;

          # line numbers
          number = true;
          relativenumber = true;
          wrap = false;
          cursorline = true;
          scrolloff = 8;
          sidescrolloff = 5;

          # search
          ignorecase = true;
          smartcase = true;
          incsearch = true;
          hlsearch = true;

          # swap
          swapfile = false;
          backup = false;
          writebackup = false;
          undofile = true;

          # text stuff
          list = true;
          listchars = "tab:→\\ ,trail:°,extends:›,precedes:‹";
          conceallevel = 2;
          concealcursor = "nc";

          # fold your laundry
          foldmethod = "indent";
          foldlevel = 99;
          foldenable = false;
        };

        inherit keymaps;

        extraPlugins = with pkgs.vimPlugins; {
          gruvbox-material = {
            package = gruvbox-material;
            setup = ''
              vim.g.gruvbox_material_background = 'hard'
              vim.g.gruvbox_material_better_performance = 1
              vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "gruvbox-material",
                callback = function()
                  local dark_bg = "#0e0e0e"
                  local groups = {
                    "Normal", "NonText", "SignColumn", "FoldColumn",
                    "NormalFloat", "NvimTreeNormal", "NvimTreeEndOfBuffer"
                  }
                  
                  for _, group in ipairs(groups) do
                    vim.api.nvim_set_hl(0, group, { bg = dark_bg })
                  end
                  vim.api.nvim_set_hl(0, "FloatBorder", { bg = dark_bg, fg = "#3c3836" })
                  vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = dark_bg, bg = dark_bg })
                  vim.api.nvim_set_hl(0, "StatusLine", { bg = dark_bg })
                  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = dark_bg })
                end,
              })

              vim.cmd('colorscheme gruvbox-material')
            '';
          };

          snacks = {
            package = snacks-nvim;
            setup = "
              require('snacks').setup({
                bigfile = { enabled = true },
                dashboard = { enabled = false },
                indent = { enable = false },
                quickfile = { enable = true },
                statuscolumn = { enable = true },
                words = { enable = true },
              })
            ";
          };
        };

        lsp.enable = true;
        languages = {
          enableTreesitter = true;

          nix = {
            enable = true;
            lsp = {
              enable = true;
              servers = [ "nixd" ];
            };
            format = {
              enable = true;
              type = [ "nixfmt" ];
            };
          };

          typescript.enable = true;
          css.enable = true;
          json.enable = true;
          lua.enable = true;
          markdown.enable = true;
          docker.enable = true;
          helm.enable = true;
          yaml.enable = true;
          python.enable = true;
        };

        visuals = {
          indent-blankline = {
            enable = true;
            setupOpts = {
              indent = {
                char = "▏";
                tab_char = "▏";
              };
              scope = {
                enabled = true;
                show_start = true;
                show_end = false;
              };
            };
          };
          nvim-web-devicons.enable = true;
        };

        binds.whichKey = {
          enable = true;
          register = {
            "<leader>e" = "+Explorer";
            "<leader>l" = "+Git";
            "<leader>x" = "+Diagnostics";
          };
        };

        autocomplete.blink-cmp = {
          enable = true;
          friendly-snippets.enable = true;
          setupOpts = {
            keymap.preset = "super-tab";
            completion.documentation.auto_show_delay_ms = 150;
          };
        };

        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        notes.todo-comments.enable = true;

        filetree.nvimTree = {
          enable = true;
          openOnSetup = false;

          setupOpts = {
            view = {
              width = 35;
              side = "left";
            };

            renderer = {
              group_empty = true;
              indent_markers.enable = true;
            };

            filters = {
              dotfiles = false;
              git_ignored = true;
            };

            git.enable = true;

            update_focused_file = {
              enable = true;
              update_root = true;
            };
          };
        };

        statusline.lualine = {
          enable = true;
          theme = "auto";
          sectionSeparator = {
            left = "";
            right = "";
          };
          componentSeparator = {
            left = "";
            right = "";
          };
        };

        telescope = {
          enable = true;
          extensions = [
            {
              name = "fzf";
              packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
              setup = {
                fzf = {
                  fuzzy = true;
                  override_file_sorter = true;
                  override_generic_sorter = true;
                  case_mode = "smart_case";
                };
              };
            }
          ];
          setupOpts = {
            defaults = {
              layout_config.horizontal.prompt_position = "top";
              sorting_strategy = "ascending";
            };
            pickers.find_files.hidden = true;
          };
        };

        git.gitsigns = {
          enable = true;
          setupOpts = {
            attach_to_untracked = true;
            current_line_blame = true;
            current_line_blame_opts = {
              delay = 0;
              virt_text_pos = "eol";
            };
          };
        };

        terminal.toggleterm = {
          enable = true;
          lazygit = {
            enable = true;
            mappings.open = "<leader>lg";
          };
        };

        dashboard.dashboard-nvim = {
          enable = true;
          setupOpts = {
            theme = "doom";
            config = {
              header = [
	              "                                                                       "
	              "                                                                     "
	              "       ████ ██████           █████      ██                     "
	              "      ███████████             █████                             "
	              "      █████████ ███████████████████ ███   ███████████   "
	              "     █████████  ███    █████████████ █████ ██████████████   "
	              "    █████████ ██████████ █████████ █████ █████ ████ █████   "
	              "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
	              " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
	              "                                                                       "
              ];
              header_h1 = [
                "DashboardGrad1"
                "DashboardGrad2"
                "DashboardGrad3"
                "DashboardGrad4"
              ];
              center = [
                {
                  icon = " ";
                  desc = "Find file";
                  key = "f";
                  action = "Telescope find_files";
                }
                {
                  icon = " ";
                  desc = "Live grep";
                  key = "g";
                  action = "Telescope live_grep";
                }
                {
                  icon = " ";
                  desc = "File tree";
                  key = "e";
                  action = "NvimTreeToggle";
                }
                {
                  icon = " ";
                  desc = "Quit";
                  key = "q";
                  action = "qa";
                }
              ];
              footer = [ "Tip: press ? for which-key" ];
            };
          };
        };

        utility = {
          oil-nvim = {
            enable = true;
            setupOpts = {
              columns = [ "icon" "permission" "size" ];
              view = {
                show_hidden = true;
              };
            };
          };

          surround.enable = true;
        };

        theme.enable = false; 
      };
    };
  };
}
