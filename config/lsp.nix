{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    #typescript-tools-nvim
  ];
  plugins.lsp = {
    enable = true;

    servers = {
      ruff.enable = true;
      nginx-language-server.enable = true;
      pylsp = {
        enable = true;
        settings.plugins.flake8.enabled = true;
      };
      pyright.enable = true;
      gopls.enable = true;
      bashls.enable = true;
      dockerls.enable = true;
      sqls.enable = true;
      nil-ls = {
        enable = true;
        extraOptions = {
          formatting.command = "alejandra";
        };
      };
      svelte.enable = false;
      html.enable = false;
      ts-ls.enable = false;
      lua-ls.enable = true;
      terraformls.enable = true;
    };
    keymaps = {
      silent = true;
      diagnostic = {
        "]g" = "goto_next";
        "[g" = "goto_prev";
      };
      lspBuf = {
        "gd" = "definition";
        "gr" = "references";
      };
    };
  };
}
