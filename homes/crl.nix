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
    switch = "nix run nix-darwin -- switch --flake $HOME/projects/setup";
  };
}
