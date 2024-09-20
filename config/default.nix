{
  config,
  lib,
  ...
}: {
  # TODO get inspiration from here: git@github.com:pete3n/nixvim-flake.git
  # for a more complete dev environment
  imports = [
    ./lsp.nix
    ./format.nix
    ./completion.nix
    ./telescope.nix
  ];
  enableMan = true;
  colorschemes.gruvbox.enable = true;
  globals = {
    mapleader = " ";
    netrw_banner = 0;
  };
  keymaps = let
    splits =
      lib.attrsets.mapAttrsToList (
        name: value: {
          mode = "n";
          key = name;
          action.__raw = ''require("smart-splits").${value}'';
        }
      ) {
        # Resizinta
        # for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
        "<A-h>" = "resize_left";
        "<A-j>" = "resize_down";
        "<A-k>" = "resize_up";
        "<A-l>" = "resize_right";
        # Moving
        "<C-h>" = "move_cursor_left";
        "<C-j>" = "move_cursor_down";
        "<C-k>" = "move_cursor_up";
        "<C-l>" = "move_cursor_right";
        "<C-\\>" = "move_cursor_previous";
        #  swapping buffers between windows
        "<leader><leader>h" = "swap_buf_left";
        "<leader><leader>j" = "swap_buf_down";
        "<leader><leader>k" = "swap_buf_up";
        "<leader><leader>l" = "swap_buf_right";
      };
  in
    [
      {
        mode = "n";
        key = "<leader>lg";
        options.silent = true;
        action = ":LazyGit<CR>";
      }
      {
        mode = "n";
        key = "<C-n>";
        options.silent = true;
        action = ":call ToggleVExplorer()<CR>";
      }
      {
        mode = "n";
        key = "<leader>h";
        options.silent = true;
        action = ":Gitsigns preview_hunk<CR>";
      }
      {
        mode = "n";
        key = "<leader>nh";
        options.silent = true;
        action = ":Gitsigns next_hunk<CR>";
      }
      {
        mode = "n";
        key = "<leader>sh";
        options.silent = true;
        action = ":Gitsigns stage_hunk<CR>";
      }
    ]
    ++ splits;

  opts = {
    updatetime = 100;
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    softtabstop = 2;
    tabstop = 2;
    expandtab = true;
    ff = "unix";
    guifont = "Fira Code:h11";
    encoding = "utf-8";
    mouse = "a";
    undofile = true;
    undodir = "$$XDG_CACHE_HOME/.cache/nvim/undodir";
  };

  # To remove lualine defaults you needs to set {} in lua,
  # because nixvim ignores this even with mkForce and fallsbacks
  # to the default of lualine
  # Here are the defaults:
  # https://github.com/nix-community/nixvim/blob/main/plugins/statuslines/lualine.nix#L168-L176
  extraConfigLuaPost = ''
    local current_lua_config = require('lualine').get_config()
    current_lua_config.sections = {
        ["lualine_a"] = {},
        ["lualine_z"] = {},
    }
    require('lualine').setup(current_lua_config)
  '';
  extraConfigVim = ''
    command! WQ wq
    command! Wq wq
    command! W w
    command! Q q
    cmap w!! w !sudo tee > /dev/null %
    autocmd FileType markdown setlocal spell spelllang=en_us
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd FileType markdown set conceallevel=2
    function! ToggleVExplorer()
      if exists("t:expl_buf_num")
          let expl_win_num = bufwinnr(t:expl_buf_num)
          if expl_win_num != -1
              let cur_win_nr = winnr()
              exec expl_win_num . 'wincmd w'
              close
              exec cur_win_nr . 'wincmd w'
              unlet t:expl_buf_num
          else
              unlet t:expl_buf_num
          endif
      else
          Vexplore
          let t:expl_buf_num = bufnr("%")
      endif
    endfunction
  '';

  plugins = {
    trouble.enable = true;
    nvim-autopairs.enable = true;
    smart-splits.enable = true;
    lazygit.enable = true;
    neogit.enable = false;
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "eol";
        };
        signs = {
          add = {text = "+";};
          change = {text = "~";};
          delete = {text = "_";};
          topdelete = {text = "‾";};
          changedelete = {text = "~";};
        };
      };
    };
    zen-mode.enable = true;
    twilight.enable = true;
    hardtime = {
      maxCount = 10;
      enable = false;
    };
    noice = {
      enable = true;
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
    };
    lualine = {
      enable = true;
      alwaysDivideMiddle = true;
      iconsEnabled = true;
      globalstatus = true;
      theme = "codedark";
      componentSeparators.left = "";
      sections = {
        /*
        lualine_b = [
          "branch"
          "diff"
        ];
        lualine_c = [
          {
            name = "filetype";
            extraConfig.icon_only = true;
          }
          {
            name = "filename";
            extraConfig.path = 4;
          }
        ];
        /*

        lualine_x = lib.mkForce [
          "diagnostics"
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
        */
      };
    };
  };
}
