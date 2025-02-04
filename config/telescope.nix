{ ... }: {
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
    };
    settings.pickers = {
      live_grep.__raw = /* lua */ ''
        {
          additional_args = function(opts)
            return {"--hidden", "-g", "!.git/**", "-g", "!flake.lock"}
          end
        }
      '';
      /*
      find_files.__raw =  ''
        { 
          find_files = {
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
          },
        }
      '';
      */
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
