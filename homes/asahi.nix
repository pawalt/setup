{ config, pkgs, ... }:

{
  # USER DATA
  home.username = "peyton";
  home.homeDirectory = "/home/peyton";

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
    switch = "home-manager switch --flake $HOME/projects/setup";
  };
}
