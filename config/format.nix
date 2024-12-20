{ pkgs, ... }: {
  /*
    extraPackages = with pkgs;[
    nixpkgs-fmt
    prettierd
    stylua
    rustfmt
    prettierd
    isort
    black
    go
    ];
    plugins.conform-nvim = {
    enable = false;
    settings = {
      formatters_by_ft = {
        css = [ "prettierd" "prettier" ];
        go = [ "goimports" "gofumpt" "golines" ];
        html = [ "prettierd" "prettier" ];
        javascript = [ "prettierd" "prettier" ];
        javascriptreact = [ "prettier" ];
        json = [ "prettier" ];
        svelte = [ "prettier" ];
        lua = [ "stylua" ];
        markdown = [ "prettier" ];
        nix = [ "nixpkgs-fmt" ];
        python = [ "isort" "black" ];
        rust = [ "rustfmt" ];
        sh = [ "shfmt" ];
        typescript = [ "prettierd" "prettier" ];
        typescriptreact = [ "prettier" ];
        yaml = [ "prettierd" "prettier" ];
      };
      format_on_save = {
        lsp_fallback = true;
        timeout_ms = 2000;
      };

      extraConfigLuaPre = ''
        -- Formatting function for conform
        _G.format_with_conform = function()
              	local conform = require("conform")
              	conform.format({
                    		lsp_fallback = true,
                    		async = true,
                    		timeout_ms = 2000,
              	})
        end
      '';
    };
    };
  */
}
