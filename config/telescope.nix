{ ... }: {
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      file-browser.enable = false;
      file-browser.settings = {
        hijack_netrw = true;
        hidden = {
          file_browser = true;
        };
        cwd_to_path = true;
        auto_depth = true;
        collapse_dirs = false;
      };
    };
    settings.mappings = {
      i = {
        "<C-j>" = {
          __raw = "move_selection_next";
        };
        "<C-k>" = {
          __raw = "move_selection_previous";
        };
      };
    };
    keymaps = {
      "<leader>fg" = "live_grep";
      "<leader>ff" = "find_files";
      "<leader>fb" = "file_browser";
      "<leader>gs" = {
        action = "git_status";
        options.desc = "Status";
      };
      "<leader>gc" = {
        action = "git_commits";
        options.desc = "Commits";
      };
    };
  };
}
