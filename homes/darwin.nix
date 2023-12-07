{ config, pkgs, ... }:

{
  programs.zsh.shellAliases = {
    switch = "nix run nix-darwin -- switch --flake $HOME/projects/setup";
  };
}