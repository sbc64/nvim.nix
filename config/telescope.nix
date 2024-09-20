{...}: {
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
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
