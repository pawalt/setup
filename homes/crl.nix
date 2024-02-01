{ config, pkgs, ... }:

{
  # PROGRAM CONFIG
  programs.git = {
    enable = true;
    userName  = "Peyton Walters";
    userEmail = "peyton@cockroachlabs.com";
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

  programs.zsh = {
    # we use rancher at work
    initExtra = '' 
      export PATH=$HOME/.rd/bin:$HOME/go/src/github.com/cockroachlabs/managed-service/bin:$PATH
    '';

    shellAliases = {
      gmpr = "git machete github create-pr --draft";
    };
  };

  home.packages = with pkgs; [
    google-cloud-sdk
  ];
}
