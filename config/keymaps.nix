{ lib
, ...
}: {
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
      } ++
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
        action = ":NvimTreeToggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>s";
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
        key = "<leader>h";
        options.silent = true;
        action = ":Gitsigns show HEAD<CR>";
      }
      {
        mode = "n";
        key = "<leader>tld";
        action = "<Plug>(toggle-lsp-diag)";
        options.desc = "Toggle LSP diagnostics";
      }
    ];
}
