{ config
, lib
, pkgs
, ...
}:
let
  rust = pkgs.fenix.stable.completeToolchain or pkgs.rust-analyzer;
in
{
  extraPackages =
    map
      (pkg:
        pkgs.${pkg}
          or (with pkgs; {
          golangcilint = golangci-lint;
          inherit nixpkgs-fmt;
          inherit nixd;
        }).${pkg})
      (lib.flatten (lib.attrValues config.plugins.lint.lintersByFt));

  plugins = {
    fzf-lua.enable = true; #needed by some package but it is not enabled by default
    lint = {
      enable = true;
      lintersByFt = {
        css = [ "eslint_d" ];
        scss = [ "eslint_d" ];
        gitcommit = [ "commitlint" ];
        go = [ "golangcilint" ];
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        markdownlint = [ "markdownlint-cli2" ];
        nix = [ "deadnix" "nix" "statix" ];
        python = [ "ruff" ];
        sh = [ "shellcheck" ];
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        yaml = [ "yamllint" ];
      };
      # https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/yamllint.lua
      linters.yamllint = {
        cmd = "${pkgs.yamllint}/bin/yamllint";
        stdin = true;
        stream = "stdout";
        args = [
          "--config-file"
          "${pkgs.writeText "yamllint-config.yaml" /* yaml */ ''
          extends: default
          rules:
            document-start:
              present: false
            line-length:
              max: 80
        ''}"
          "parsable"
          "-"
        ];
        ignore_exitcode = true;
        parser = ''require('lint.parser').from_pattern(pattern, groups, severities, {
          ['source'] = 'yamllint',
        })'';
      };
      # Trigger linting more aggressively, not only after writing a buffer
      autoCmd.event = [ "BufWritePost" "BufEnter" "BufLeave" ];
    };
    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
        };
      };

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        json
        make
        markdown
        nix
        regex
        toml
        lua
        yaml
      ];
    };
    lsp-format.enable = true;
    lsp-signature = {
      enable = true;
    };
    lsp = {
      enable = true;
      servers = {
        ansiblels.enable = true;
        bashls.enable = true;
        cssls.enable = true;
        docker_compose_language_service.enable = false;
        dockerls.enable = true;
        eslint.enable = true;
        html.enable = true;
        jsonls.enable = true;
        marksman.enable = true;
        lua_ls.enable = true;
        nixd = {
          enable = true;
          cmd = [
            "nixd"
            "--semantic-tokens=0"
          ];
          filetypes = [
            "nix"
          ];
          settings = {
            formatting.command = [
              "nixpkgs-fmt"
            ];
            nixpkgs.expr = "import <nixpkgs> { }";
            options = {
              nixos = {
                expr = ''builtins.getFlake ("git+file://" + toString ./.).nixosConfigurations.australis.options'';
              };
              home-manager = {
                expr = ''builtins.getFlake ("git+file://" + toString ./.).homeConfigurations.australis.options'';
              };
              common = {
                expr = ''builtins.getFlake ("git+file://" + toString /home/sebas/repos/common)'';
              };
            };
          };
        };
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          package = rust;
        };
        sqls.enable = true;
        ts_ls.enable = true;
        typos_lsp.enable = false;
        yamlls = {
          # https://github.com/redhat-developer/yaml-language-server?tab=readme-ov-file#language-server-settings
          settings = {
            format.enable = true;
            customTags = [
              "!reference Sequence"
            ];
          };
          enable = true;
        };
      };
    };
  };
}
