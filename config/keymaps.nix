{ lib, ... }: {
  plugins.lsp.keymaps = {
    silent = true;
    diagnostic = {
      "[d" = {
        action = "goto_prev";
        desc = "Go to prev diagnostic";
      };
      "]d" = {
        action = "goto_next";
        desc = "Go to next diagnostic";
      };
      "<leader>e" = {
        action = "open_float";
        desc = "Show Line Diagnostics";
      };
    };
    lspBuf = {
      "<leader>ca" = {
        action = "code_action";
        desc = "Code Actions";
      };
      "<leader>rn" = {
        action = "rename";
        desc = "Rename Symbol";
      };
      "<leader>fm" = {
        action = "format";
        desc = "Format";
      };
      "gd" = {
        action = "definition";
        desc = "Goto definition (assignment)";
      };
      "gD" = {
        action = "declaration";
        desc = "Goto declaration (first occurrence)";
      };
      "gr" = {
        action = "references";
        desc = "Goto references";
      };
      "gy" = {
        action = "type_definition";
        desc = "Goto Type Definition";
      };
      "gi" = {
        action = "implementation";
        desc = "Goto Implementation";
      };
      "<leader>k" = {
        action = "hover";
        desc = "Hover";
      };
      "<leader>ls" = {
        action = "signature_help";
        desc = "Signature Help";
      };
    };
  };
  keymaps =
    lib.attrsets.mapAttrsToList
      (
        name: value: {
          mode = "n";
          key = name;
          action.__raw = ''require("smart-splits").${value}'';
        }
      )
      {
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
        #"<C-\\>" = "move_cursor_previous";
        #  swapping buffers between windows
        "<leader><leader>h" = "swap_buf_left";
        "<leader><leader>j" = "swap_buf_down";
        "<leader><leader>k" = "swap_buf_up";
        "<leader><leader>l" = "swap_buf_right";
      }
    ++ [
      # Use tab as buffer switcher in normal mode
      {
        mode = "n";
        key = "<Tab>";
        action = ":bnext<CR>";
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = ":bprevious<CR>";
      }
      {
        mode = "n";
        key = "<BS>";
        action = ":nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "tn";
        options.silent = true;
        action = ":tabnew %<CR>";
      }
      {
        mode = "n";
        key = "tc";
        options.silent = true;
        action = ":tabclose<CR>";
      }
      {
        mode = "n";
        key = "<C-n>";
        options.silent = true;
        action = ":NvimTreeToggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>p";
        options.silent = true;
        action = ":Gitsigns preview_hunk_inline<CR>";
      }
      {
        mode = "n";
        key = "<leader>sh";
        options.silent = true;
        action = ":Gitsigns stage_hunk<CR>";
      }
      {
        mode = "n";
        key = "<leader>dd";
        options.silent = true;
        action = ":bp\|bd #<CR>";
      }
      {
        mode = "n";
        key = "<leader>hh";
        options.silent = true;
        action = ":Gitsigns show HEAD<CR>";
      }
      {
        mode = "n";
        key = "<leader>ld";
        action = ":lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>";
        options = {
          desc = "Toggle LSP diagnostics";
          silent = true;
          noremap = true;
        };
      }
    ];
}
