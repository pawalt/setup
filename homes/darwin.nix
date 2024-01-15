{ config, pkgs, ... }:

{
  programs.zsh.shellAliases = {
    switch = "nix run nix-darwin -- switch --flake $HOME/projects/setup";

    ss = "sudo lsof -PiTCP -sTCP:LISTEN";
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  nixpkgs.overlays = [
    # this shit broken and i dont wanna fix it rn
    # (import ../overlays/ollama.nix)
  ];

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

  home.packages = with pkgs; [
    # no point to running on linux because need m1 drivers go brrr
    ollama
  ];
}
