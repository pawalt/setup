{ config, pkgs, ... }:

{
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

  programs.zsh.shellAliases = {
    gmpr = "git machete github create-pr";
  };
}
