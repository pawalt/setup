{ config, pkgs, ... }:

{
  # USER DATA
  home.username = "peyton";
  home.homeDirectory = "/home/peyton";

  home.stateVersion = "23.11";

  # PROGRAM CONFIG

  programs.git = {
    enable = true;
    userName  = "Peyton Walters";
    userEmail = "pawalt@hey.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autostash = true;
      };
    };
  };

  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs; [
      vimPlugins.gruvbox
      vimPlugins.nerdtree
    ];

    extraConfig = ''
      syntax enable
      colorscheme gruvbox
      set background=dark

      set tabstop=2
      set shiftwidth=2
      set expandtab

      "" Nerdtree CONFIG
      
      " auto-open if no args are set
      autocmd VimEnter * if !argc() | NERDTree | endif

      " Nerdtree tab configuration
      function! IsNerdTreeEnabled()
        return exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
      endfunction
      function! TreeTab()
        if IsNerdTreeEnabled()
          execute 'tabe'
          execute 'NERDTreeMirror'
        else
          execute 'tabe'
        endif
      endfu
      nnoremap <Space>t :call TreeTab()<CR>

      " navigation
      nnoremap <Space>j <C-W><C-J>
      nnoremap <Space>h <C-W><C-H>
      nnoremap <Space>j <C-W><C-K>
      nnoremap <Space>l <C-W><C-L>
    '';
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      bbenoist.nix 
      golang.go
      ms-python.vscode-pylance
      redhat.vscode-yaml
    ];

    userSettings = {
      "keyboard.dispatch" = "keyCode";
    };
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
        p = "ping";
        rg = "grep -ir";
        pg = "ping google.com";
        p8 = "ping 8.8.8.8";
        l = "ls -CF";
        ll = "ls -alh";
        k = "kubectl";
        tf = "terraform";
        cat = "bat -P --style=plain";

        gs = "git status";
        ga = "git add";
        gi = "git commit";
        gia = "git commit --amend";
        gian = "git commit --amend --no-edit";
        upd = "git commit --amend --no-edit && git push -f";

        switch = "home-manager switch --flake $HOME/projects/setup";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "dracula/zsh"; tags = [ as:theme ]; }
        { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
        { name = "zsh-users/zsh-autosuggestions"; }
      ];
    };
  };

  home.packages = with pkgs; [
    figlet
    bat
    gh

    # go stuff
    go
    gotools
    gopls
    golint
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {};

  programs.home-manager.enable = true;
}
