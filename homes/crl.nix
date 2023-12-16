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

  programs.zsh.shellAliases = {
    gmpr = "git machete github create-pr --draft";
  };
}
