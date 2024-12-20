{ config, ... }: {
  extraConfigLuaPre = /* lua */ ''
    local luasnip = require('luasnip')
    local has_space_before = function()
      local unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      if col == 0 then
        return false
      end

      local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      local char_before_cursor = current_line:sub(col, col)

      return char_before_cursor == ' '
    end

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    -- Needed by lint in default.nix
    local pattern = 'stdin:(%d+):(%d+): %[(.+)%] (.+) %((.+)%)'
    local groups = { 'lnum', 'col', 'severity', 'message', 'code' }
    local severities = {
      ['error'] = vim.diagnostic.severity.ERROR,
      ['warning'] = vim.diagnostic.severity.WARN,
    }
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
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-;>" = "cmp.mapping.complete()";
        };

        sources = [
          { name = "nvim_lsp"; }
          { name = "cmp_tabby"; }
          { name = "luasnip"; }
          { name = "path"; }
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

