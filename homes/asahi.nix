{ config, pkgs, ... }:

{
  programs.zsh.shellAliases = {
    # need to go impure because of experimental gpu drivers
    # would love to do overlay but my computer shit the bed
    # while rebuilding the world.
    # https://github.com/tpwrules/nixos-apple-silicon/blob/14b327ca47703c376ebb82ba16dc42ca2baa57d8/apple-silicon-support/modules/mesa/default.nix#L55
    switch = "sudo nixos-rebuild switch --impure --flake $HOME/projects/setup";
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

  programs.plasma = {
    enable = true;

    workspace = {
      theme = "breeze-dark";
    };

    shortcuts = {
      kwin = {
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";

        "Window to Desktop 1" = "Alt+1";
        "Window to Desktop 2" = "Alt+2";
        "Window to Desktop 3" = "Alt+3";
        "Window to Desktop 4" = "Alt+4";

        "Window Fullscreen" = "F11";
      };
    };

    configFile = {
      "kwinrc"."Xwayland"."Scale" = 2;
    };
  };
}
