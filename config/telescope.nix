{ ... }: {
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      live-grep-args = {
        enable = true;
        settings.additional_args = [
          "--hidden"
        ];
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
