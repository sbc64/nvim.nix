{ lib
, config
, ...
}:
let
  copilot = false;
in
{
  plugins = {
    copilot-chat = {
      enable = copilot;
    };
    copilot-lua = {
      enable = copilot;
    };
    copilot-cmp = {
      enable = copilot;
    };
    wakatime.enable = false;
    firenvim.enable = false;
    vim-bbye.enable = false;
    web-devicons.enable = true;
    nvim-tree = {
      enable = true;
      disableNetrw = true;
      tab.sync.close = true;
      openOnSetup = false;
      view = {
        float = {
          enable = true;
          openWinConfig.__raw = /** lua **/ ''
            {
              relative = "editor",
              width = 80,
              height = 40,
              col = (vim.api.nvim_list_uis()[1].width - 80) * 0.5,
              row = (vim.api.nvim_list_uis()[1].height - 40) * 0.4,
              }
          '';
        };

        number = false;
        relativenumber = false;
        signcolumn = "no";
      };
    };
    trouble.enable = true;
    nvim-autopairs.enable = true;
    smart-splits.enable = true;
    lazygit = {
      enable = !config.plugins.toggleterm.enable;
      settings.configFilePath = "/home/sebas/.config/lazygit/config.yml";
    };
    fugitive = { enable = false; };
    diffview = {
      enable = true;
    };
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = false;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol";
        };
        signs = {
          add = { text = "+"; };
          change = { text = "~"; };
          delete = { text = "_"; };
          topdelete = { text = "‾"; };
          changedelete = { text = "~"; };
        };
      };
    };
    zen-mode.enable = true;
    zen-mode.settings = {
      plugins.twilight.enabled = false;
      window = {
        backdrop = 0.7;
        width = 0.7;
      };
    };
    twilight.enable = true;
    hardtime = {
      settings = {
        max_count = 15;
        disable_mouse = false;
      };
      enable = false;
    };
    schemastore = {
      enable = true;
      json.enable = true;
      yaml.enable = true;
    };
    toggleterm = {
      enable = true;
      settings = {
        open_mapping = "[[<c-t>]]";
      };
      luaConfig.post = /* lua */ ''
        function _G.set_terminal_keymaps()
          local opts = {buffer = 0}
          -- TODO: move theses to keymaps.nix
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
          vim.keymap.set('t', '<C-w>', [[<C-t><C-n><C-w>]], opts)
        end

        local Terminal  = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({
          cmd = "lazygit",
          dir = "git_dir",
          direction = "float",
          float_opts = {
            border = "double",
          },
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
          end,
          -- function to run on closing the terminal
          on_close = function(term)
            vim.cmd("startinsert!")
          end,
        })

        function _lazygit_toggle()
          lazygit:toggle()
        end

        -- TODO: move this to keymaps.nix
        vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
        -- if you only want thesa mappings for toggle term use term://*toggleterm#* instead
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
      '';
    };
    noice = {
      enable = true;
      settings = {
        messages.enabled = true; # Needed to hide the cmdline
        notify.enabled = true; # Needed to hide the cmdline
        health.checker = false;
        cmdline = {
          enabled = true;
          # https://github.com/folke/noice.nvim/wiki/Configuration-Recipes
          view = "cmdline";
          format = {
            cmdline = {
              pattern = "^:";
              icon = "";
              lang = "vim";
            };
          };
        };
        presets = {
          bottom_search = false;
          command_palette = false;
          inc_rename = false;
          long_message_to_split = true;
          lsp_doc_border = true;
        };
      };
    };

    bufferline = {
      enable = true;
      settings.options.numbers = "ordinal";
    };
    rainbow-delimiters.enable = true;
    lastplace.enable = true;
    lualine = {
      enable = true;
      # To remove lualine defaults you needs to set {} in lua,
      # because nixvim ignores this even with mkForce and fallbacks
      # to the default of lualine
      # Here are the defaults:
      # https://github.com/nix-community/nixvim/blob/main/plugins/statuslines/lualine.nix#L168-L176
      luaConfig.post = ''
        local current_lua_config = require('lualine').get_config()
        current_lua_config.sections = {
            ["lualine_a"] = {},
            ["lualine_b"] = {},
            ["lualine_z"] = {},
        }
        require('lualine').setup(current_lua_config)
      '';
      settings.sections = {
        lualine_c = [
          "branch"
          "diff"
        ];
        lualine_x = [
          "diagnostics"
          {
            __unkeyed-1.__raw = ''
              name = function()
                  local msg = ""
                  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                  local clients = vim.lsp.get_active_clients()
                  if next(clients) == nil then
                      return msg
                  end
                  for _, client in ipairs(clients) do
                      local filetypes = client.config.filetypes
                      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                          return client.name
                      end
                  end
                  return msg
              end,
              icon = "",
              color = { fg = "#ffffff", },
            '';
          }
        ];
        lualine_y = [
          {
            __unkeyed-1.__raw = ''
              'tabs',
              path = 1,
              mode = 1,
            '';
          }
          "progress"
          "location"
        ];
      };
      settings.options = {
        componentSeparators.left = "";
        alwaysDivideMiddle = true;
        iconsEnabled = true;
        globalstatus = true;
        theme = "codedark";
      };
    };
  };
}
