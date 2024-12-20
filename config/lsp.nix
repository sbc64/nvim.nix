{ config, lib, pkgs, ... }:
let
  rust = pkgs.fenix.stable.completeToolchain or pkgs.rust-analyzer;
in
{
  extraPackages = map
    (pkg: pkgs.${pkg} or (with pkgs; {
      golangcilint = golangci-lint;
      inherit nixpkgs-fmt;
      inherit nixd;
    }).${pkg})
    (lib.flatten (lib.attrValues config.plugins.lint.lintersByFt));

  plugins = {
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
    lsp-format = {
      enable = true;
    };
    lsp = {
      enable = true;
      servers = {
        ansiblels.enable = true;
        bashls.enable = true;
        cssls.enable = true;
        docker-compose-language-service.enable = false;
        dockerls.enable = true;
        eslint.enable = true;
        html.enable = true;
        java-language-server = {
          enable = false;
          #rootDir.__raw = "nvim_lsp.util.root_pattern('.git');";
        };
        jsonls.enable = true;
        # does language correction even on keywords...
        #ltex.enable = true;
        marksman.enable = true;
        nixd = {
          enable = true;
          cmd = [
            "nixd"
            "--semantic-tokens=false"
          ];
          filetypes = [ "nix" ];
          settings = {
            formatting.command = [ "nixpkgs-fmt" ];
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
        nil-ls = {
          enable = false;
          settings = {
            formatting.command = [ "nixpkgs-fmt" ];
          };
        };
        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          package = rust;
        };
        sqls.enable = true;
        taplo.enable = true;
        texlab.enable = true;
        tsserver.enable = true;
        typos-lsp.enable = false;

        yamlls.enable = true;
        lemminx.enable = true;
      };

      keymaps = {
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
    };
  };
}
