{ config, ... }: {
  extraConfigLuaPre = /* lua */ ''
    local luasnip = require('luasnip')
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match(".%s") == nil
    end
  '';
  plugins = {
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      #fromVscode = [
      #  {
      #    lazyLoad = true;
      #    paths = "${pkgs.vimPlugins.friendly-snippets}";
      #  }
      #];
    };

    lspkind = {
      enable = true;
      cmp = {
        enable = true;
        menu = {
          nvim_lsp = "[LSP]";
          cmp_tabby = "[Tabby]";
          nvim_lua = "[api]";
          path = "[path]";
          luasnip = "[snip]";
          buffer = "[buffer]";
        };
      };
    };

    cmp = {
      enable = true;

      settings = {
        snippet.expand = /* lua */ ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        mapping =
          let
            cmpWinHeight = config.opts.pumheight;

          in
          {
            "<CR>" = /* lua */ ''
              cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                  if luasnip.expandable() then
                    luasnip.expand()
                  else
                    cmp.confirm({ select = true })
                  end
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<C-Space>" = "cmp.mapping.complete()";

            "<Tab>" = /* lua */ ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                  luasnip.jump(1)
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<S-Tab>" = /* lua */ ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';

            "<Up>" = /* lua */ ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<Down>" = /* lua */ ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                  luasnip.jump(1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<PageUp>" = /* lua */ ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item({ count = ${toString cmpWinHeight} })
                elseif luasnip.locally_jumpable(${toString (cmpWinHeight * -1)}) then
                  luasnip.jump(${toString (cmpWinHeight * -1)})
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<PageDown>" = /* lua */ ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item({ count = ${toString cmpWinHeight} })
                elseif luasnip.locally_jumpable(${toString cmpWinHeight}) then
                  luasnip.jump(${toString cmpWinHeight})
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
          };

        sources = [
          { name = "nvim_lsp"; }
          { name = "cmp_tabby"; }
          { name = "path"; }
          { name = "luasnip"; }
          {
            name = "buffer";
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
        ];
      };
    };

    cmp-tabby = {
      settings.host = "http://127.0.0.1:8080";
    };
  };
}

