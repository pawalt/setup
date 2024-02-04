{ config, pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";

  fonts.fontconfig.enable = true;

  # PROGRAM CONFIG
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      gruvbox
      nerdtree
      vim-airline
      auto-pairs
      vim-devicons
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

    # sometimes have to `rm -rf ~/.vscode/extensions`. very much wish i knew why
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      bbenoist.nix
      golang.go
      ms-python.vscode-pylance
      redhat.vscode-yaml
      github.copilot
      bodil.file-browser
      ms-azuretools.vscode-docker
      ms-python.python
      ms-python.black-formatter
      eamodio.gitlens
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
      {
        name = "fzf-quick-open";
        publisher = "rlivings39";
        version = "0.5.1";
        sha256 = "c467019779a6cb2f99b27f4e9dc0c36c9562331120bec463933cbcf4d3c9a52f";
      }
      {
        name = "vscode-intellij-recent-files";
        publisher = "percygrunwald";
        version = "1.1.1";
        sha256 = "a94cf4102accc72e5530628492aeac6a43fa43cba54b61a79b58878b5c1beb25";
      }
      {
        name = "sqltools";
        publisher = "mtxr";
        version = "0.28.1";
        sha256 = "3f30db1fda58788ce63053a43ccb1ba39a4d19723aaaeb1a025c0ceac93db35d";
      }
      {
        name = "vscode-search-everywhere";
        publisher = "kbysiec";
        version = "2.1.0";
        sha256 = "e59df9faeaa46df4f4931720676df9af248eed6bc652f28fe7614b534a686a63";
      }
    ];

    userSettings = {
      "keyboard.dispatch" = "keyCode";
      "editor.fontFamily" = "Hack Nerd Font";
      "workbench.colorTheme" = "Gruvbox Dark (Medium)";

      # slim down scroll + map ui
      "editor.minimap.enabled" = false;
      "editor.hideCursorInOverviewRuler" = true;
      "editor.overviewRulerBorder" = false;

      # show compact single tabs with bread crumbs
      "workbench.editor.showTabs" = "single";
      "window.density.editorTabHeight" = "compact";
      "workbench.editor.tabSizingFixedMinWidth" = 100;
      "breadcrumbs.enabled" = true;
      # "workbench.activityBar.location" = "hidden";

      # auto save when switching contexts so no zombie files
      "files.autoSave" = "onFocusChange";

      "searchEverywhere.include" = "**/*.{js,jsx,ts,tsx,go}";

      "editor.lineNumbers" = "relative";
      "vim.useSystemClipboard" = true;
      "vim.hlsearch" = true;
      "vim.normalModeKeyBindingsNonRecursive" = [
          # search and file lookup
          { before = ["<Space>" "<Space>"]; commands = [ "extension.intellijRecentFiles" ]; }
          # need to replace this with some fzf jawn. this too slow
          { before = ["<Space>" "f"]; commands = [ "searchEverywhere.search" ]; }
          { before = ["<Space>" "o"]; commands = [ "file-browser.open" ]; }

          # split window in both directions
          { before = ["<Space>" "w" "v" ]; after = [ "<C-w>" "<C-v>" ]; }
          { before = ["<Space>" "w" "s" ]; after = [ "<C-w>" "<C-s>" ]; }
          { before = ["<Space>" "w" "c" ]; commands = [ "workbench.action.closeEditorsInGroup" ]; }

          # problems
          { before = ["<Space>" "p" "n" ]; commands = [ "editor.action.marker.next" ]; }
          { before = ["<Space>" "p" "p" ]; commands = [ "editor.action.marker.previous" ]; }

          # code
          { before = ["<Space>" "c" "r" ]; commands = [ "editor.action.rename" ]; }

          { before = ["<Space>" "a" "p" ]; commands = [ "workbench.files.action.focusFilesExplorer" ]; }
          { before = ["<Space>" "a" "t"]; commands = [ "workbench.action.terminal.toggleTerminal" ]; }
          { before = ["<Space>" "a" "c" "p" ]; commands = [ "workbench.action.closeSidebar" ]; }
          { before = ["<Space>" "a" "c" "t" ]; commands = [ "workbench.action.closePanel" ]; }

          # spacemacs-like window navigation
          { before = ["<Space>" "j"]; after = ["<C-w>" "<C-j>"]; }
          { before = ["<Space>" "h"]; after = ["<C-w>" "<C-h>"]; }
          { before = ["<Space>" "k"]; after = ["<C-w>" "<C-k>"]; }
          { before = ["<Space>" "l"]; after = ["<C-w>" "<C-l>"]; }
          { before = ["H"]; commands = [ "workbench.action.navigateBack" ]; }
          { before = ["L"]; commands = [ "workbench.action.navigateForward" ]; }
      ];

      keybindings = [
        {
          key = "escape";
          command = "workbench.action.focusActiveEditorGroup";
          when = "!editorTextFocus";
        }
      ];
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

  programs.htop = {
    enable = true;
  };

  programs.zsh = {
    enable = true;

    defaultKeymap = "emacs";

    shellAliases = {
        p = "ping";
        pg = "ping google.com";
        p8 = "ping 8.8.8.8";

        cat = "bat -P --style=plain";

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

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
    };

    initExtra = ''
    # macos upgrades sometimes fuck the nix path so recover if that happens.
    [[ ! $(command -v nix) && -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]] && source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

    # refresh whatever the main branch is
    function ref() {
      main_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
      cur_branch=$(git branch --show-current)
      git checkout $main_branch && git pull && git checkout $cur_branch
    }

    neofetch
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
        { name = "zsh-users/zsh-autosuggestions"; }
      ];
    };
  };

  services.syncthing = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    
    shellIntegration = {
      mode = "no-cursor";
      enableZshIntegration = true;
    };

    theme = "Gruvbox Dark Hard";
    font = {
      name = "Hack Nerd Font";
    };
  };

  home.packages = with pkgs; [
    figlet
    bat
    gh
    nerdfonts
    git-machete
    neofetch
    obsidian
    postgresql
    jq
    fzf
    ripgrep
    wget

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
    nodePackages.pnpm

    # mhm
    docker-compose

    # py
    python3
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {};
}
