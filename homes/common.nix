{ config, pkgs, inputs, unstable, ... }: let
  scriptsPath = "${config.home.homeDirectory}/projects/setup/homes/assets";
in
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
      # looking pretty
      nvim-treesitter.withAllGrammars
      gruvbox-material
      vim-airline
      vim-devicons

      # niceties
      auto-pairs
      guess-indent-nvim

      # testing
      vim-test

      # lsps and autocomplete
      nvim-lspconfig
      nvim-cmp
      luasnip
      cmp-nvim-lsp
      lsp-zero-nvim

      # 🔭
      telescope-nvim
      telescope-file-browser-nvim
    ];

    extraConfig = ''
      lua dofile("${scriptsPath}/nvim.lua")
    '';
  };

  programs.vscode = {
    enable = true;

    # sometimes have to `rm -rf ~/.vscode/extensions`. very much wish i knew why
    extensions = with pkgs.vscode-extensions; [
      # editor
      vscodevim.vim
      bodil.file-browser
      github.copilot

      # i like go
      golang.go

      # i like yaml
      redhat.vscode-yaml
      ms-azuretools.vscode-docker
      bbenoist.nix
      ms-vscode-remote.remote-ssh

      # i dont like python
      ms-python.vscode-pylance
      ms-python.python
      ms-python.black-formatter

      # i like git
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
    ];

    userTasks = {
      version = "2.0.0";
      tasks = [
        {
          label = "Launch rg-to-fzf";
          type = "shell";
          command = "${scriptsPath}/rg-to-fzf.sh";
          presentation = {
            reveal = "always";
            panel = "new";
            focus = true;
            close = true;
          };
          options = {
            cwd = "$" +  "{fileWorkspaceFolder}";
          };
          problemMatcher = [];
        }
      ];
    };

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
      "workbench.activityBar.location" = "hidden";

      # auto save when switching contexts so no zombie files
      "files.autoSave" = "onFocusChange";

      "searchEverywhere.include" = "**/*.{js,jsx,ts,tsx,go}";

      "editor.lineNumbers" = "relative";
      "vim.useSystemClipboard" = true;
      "vim.hlsearch" = true;
      "vim.normalModeKeyBindingsNonRecursive" = [
          # search and file lookup
          { before = ["<Space>" "<Space>"]; commands = [ "extension.intellijRecentFiles" ]; }
          { before = ["<Space>" "f"]; commands = [
            {
              command = "workbench.action.tasks.runTask";
              args = "Launch rg-to-fzf";
            }
          ]; }
          { before = ["<Space>" "o"]; commands = [ "file-browser.open" ]; }

          # delete but throw away result
          { before = ["<Space>" "d"]; after = [ "\"" "_" "d" ]; }
          # play macro in q
          { before = ["<Space>" "q"]; after = [ "@q" ]; }

          # split window in both directions
          { before = ["<Space>" "w" "v" ]; after = [ "<C-w>" "<C-v>" ]; }
          { before = ["<Space>" "w" "s" ]; after = [ "<C-w>" "<C-s>" ]; }
          { before = ["<Space>" "w" "c" ]; commands = [ "workbench.action.closeEditorsInGroup" ]; }
          { before = ["<Space>" "w" "o" ]; commands = [ "workbench.action.closeEditorsInOtherGroups" ]; }

          # problems
          { before = ["<Space>" "p" "n" ]; commands = [ "editor.action.marker.next" ]; }
          { before = ["<Space>" "p" "p" ]; commands = [ "editor.action.marker.previous" ]; }

          # code
          { before = ["<Space>" "c" "r" ]; commands = [ "editor.action.rename" ]; }

          # panel management
          { before = ["<Space>" "a" "p" ]; commands = [ "workbench.files.action.focusFilesExplorer" ]; }
          { before = ["<Space>" "a" "t"]; commands = [ "workbench.action.terminal.toggleTerminal" ]; }
          { before = ["<Space>" "a" "l"]; commands = [ "workbench.extensions.action.focusExtensionsView" ]; }
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
    };

    keybindings = [
      {
        key = "escape";
        command = "workbench.action.focusActiveEditorGroup";
        when = "!editorTextFocus";
      }
    ];
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
        ssh = "kitty +kitten ssh";

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
        gp = "git push";
        gcf = "git checkout $(git branch | fzf)";

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

    # say my name baby
    name=$(whoami | figlet)
    underline=$(echo "$name" | awk 'length > max_length { max_length = length } END { for(i = 1; i <= max_length; i++) printf "_"; print "" }')
    tput bold
    tput setaf 3
    echo "$underline"
    tput setaf 6
    echo "$name"
    tput setaf 3
    echo "$underline"
    tput sgr0
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
    # TODO: https://github.com/tummychow/git-absorb
    git-machete
    neofetch
    obsidian
    postgresql
    jq
    ripgrep
    wget
    fd

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
  ] ++ (with unstable; [
    # need unstable for $FZF_PROMPT in 0.46.0
    fzf
  ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".ideavimrc" = {
      source = ./assets/ideavimrc;
    };
  };
}
