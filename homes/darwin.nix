{ config, pkgs, ... }:

{
  programs.zsh.shellAliases = {
    switch = "nix run nix-darwin -- switch --flake $HOME/projects/setup";

    ss = "sudo lsof -PiTCP -sTCP:LISTEN";
  };

  # 14 pt font bc that's what plays nice with mac display scaling
  programs.kitty = {
    font = {
      size = 14;
    };
  };

  # configured system-level in nixos
  services.syncthing = {
    enable = true;
  };
}
