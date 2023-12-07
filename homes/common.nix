{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "23.11";

  fonts.fontconfig.enable = true;

  # PROGRAM CONFIG
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs; [
      vimPlugins.gruvbox
      vimPlugins.nerdtree
      vimPlugins.vim-airline
      vimPlugins.auto-pairs
      vimPlugins.vim-devicons
    ];

    extraConfig = ''
      syntax enable
      colorscheme gruvbox
      set background=dark

      set clipboard=unnamedplus

      " Airline symbols
      let g:airline_powerline_fonts = 1

      set tabstop=2
      set shiftwidth=2
      set expandtab

      "" Nerdtree CONFIG
      
      " auto-open if no args are set
      autocmd VimEnter * if !argc() | NERDTree | endif
      " close if only window left
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

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
      nnoremap <Space>k <C-W><C-K>
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
      github.copilot
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Getting this sha is annoying. I just blanked it out, ran rebuild to
      # get the sha diff (which shows up in base64), then decode it with:
      # echo "base64 hash here" | nix run nixpkgs#python3 -- -c "import base64; print(base64.decodebytes(input().encode('utf-8')).hex())"
      # thanks to mr. davis for this incantation
      {
        name = "gruvbox-themes";
        publisher = "tomphilbin";
        version = "1.0.0";
        sha256 = "0e7c00481a75cef265b8373fca1481f3b77458cf0f49bcea02fa08094470d377";
      }
    ];

    userSettings = {
      "keyboard.dispatch" = "keyCode";
      "editor.fontFamily" = "Hack Nerd Font";
      "workbench.colorTheme" = "Gruvbox Dark (Medium)";
    };
  };

  programs.starship = {
    enable = true;

    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      nodejs.disabled = true;
      rlang.disabled = true;

      golang = {
        symbol = "go ";
      };

      directory = {
        fish_style_pwd_dir_length = 1;
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
        p = "ping";
        pg = "ping google.com";
        p8 = "ping 8.8.8.8";

        cat = "bat -P --style=plain";
        grep = "grep -n";
        rg = "grep -ir";

        ls = "ls --color";
        l = "ls -CF";
        ll = "ls -alh";

        k = "kubectl";
        tf = "terraform";

        gs = "git status";
        ga = "git add";
        gi = "git commit";
        gia = "git commit --amend";
        gian = "git commit --amend --no-edit";
        upd = "git commit --amend --no-edit && git push -f";
        gc = "git checkout";

        gm = "git machete";
        gmpr = "git machete github create-pr";

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
        { name = "zsh-users/zsh-autosuggestions"; }
      ];
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    theme = "Gruvbox Dark Hard";
    font = {
      name = "Hack Nerd Font";
      size = 14;
    };
  };

  home.packages = with pkgs; [
    figlet
    bat
    gh
    nerdfonts
    git-machete

    # make lol
    gnumake
    gcc

    # go stuff
    go
    gotools
    gopls
    golint

    # node
    nodejs
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {};
}
