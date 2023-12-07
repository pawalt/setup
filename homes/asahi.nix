{ config, pkgs, ... }:

{
  # USER DATA
  home.username = "peyton";
  home.homeDirectory = "/home/peyton";

 programs.zsh.shellAliases = {
    switch = "home-manager switch --flake $HOME/projects/setup";
  };
}
