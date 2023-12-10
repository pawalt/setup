{ config, pkgs, ... }:

{
 programs.zsh.shellAliases = {
    switch = "sudo nixos-rebuild switch --flake $HOME/projects/setup";
  };

  programs.chromium = {
    enable = true;

    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
  };

  # intentionally small font cuz play with scaling
  programs.kitty = {
    font = {
      size = 10;
    };
  };
}

