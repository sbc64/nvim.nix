{ ... }: {
  # TODO get inspiration from here: git@github.com:pete3n/nixvim-flake.git
  # for a more complete dev environment
  imports = [
    ./completion.nix
    ./keymaps.nix
    ./lsp.nix
    ./plugins.nix
    ./telescope.nix
  ];
  enableMan = true;
  colorschemes.vscode.enable = true;
  globals = {
    mapleader = " ";
    netrw_banner = 0;
  };

  extraConfigLuaPost = ''
    vim.cmd("WQ wq")
    vim.cmd("WQ wq")
  '';
  extraConfigVim = ''
    command! WQ wq
    command! Wq wq
    command! W w
    command! Q q
    cabbrev wq execute "Format sync" <bar> wq
    cmap w!! w !sudo tee > /dev/null %
    autocmd FileType markdown setlocal spell spelllang=en_us
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd FileType markdown set conceallevel=2
  '';
  opts = {
    updatetime = 100;
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    softtabstop = 2;
    tabstop = 2;
    expandtab = true;
    ff = "unix";
    guifont = "Fira Code:h11";
    encoding = "utf-8";
    mouse = "a";
    undofile = true;
    # I can't user ${config.xdg.cacheHome} because this repo has no home config and it is a standlone package.
    # I have to convert this nixvim into a homeManagerModule
    #undodir = "~/.cache/nvim/undodir";
  };

}
