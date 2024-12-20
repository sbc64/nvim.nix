{ lib
, ...
}: {
  plugins = {
    web-devicons.enable = true;
    nvim-tree = {
      enable = true;
      disableNetrw = true;
      tab.sync.close = true;
      openOnSetup = false;
      view = {
        number = true;
        relativenumber = true;
        width = 40;
      };
    };
    trouble.enable = true;
    nvim-autopairs.enable = true;
    smart-splits.enable = true;
    lazygit.enable = true;
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
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
    # https://nix-community.github.io/nixvim/plugins/barbar/settings/index.html
    barbar = {
      enable = false;
    };
    zen-mode.enable = true;
    zen-mode.settings = {
      plugins.twilight.enabled = false;
    };
    twilight.enable = true;
    hardtime = {
      settings = {
        max_count = 10;
        disable_mouse = false;
      };
      enable = true;
    };
    noice = {
      enable = true;
      messages.enabled = true; # Needed to hide the cmdline
      notify.enabled = true; # Needed to hide the cmdline
      health.checker = false;
      presets = {
        bottom_search = false;
        command_palette = false;
        inc_rename = false;
        long_message_to_split = true;
        lsp_doc_border = true;
      };
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
    };
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
            ["lualine_z"] = {},
        }
        require('lualine').setup(current_lua_config)
      '';
      settings.sections = {
        lualine_b = [
          "branch"
          "commit"
          "diff"
        ];
        lualine_c = [
          {
            name = "filename";
            extraConfig.path = 3;
          }
        ];

        lualine_x = lib.mkForce [
          { name = "diagnostics"; }
          {
            name.__raw = ''
              function()
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
              end
            '';
            icon = "";
            color.fg = "#ffffff";
          }
        ];
        lualine_y = [
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
