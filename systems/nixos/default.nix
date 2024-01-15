{ config, pkgs, ... }:

{
  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  environment.shells = [pkgs.bash pkgs.zsh];
  users.defaultUserShell = pkgs.zsh;

  # Save storage space
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
    wget
    lshw
  ];

  system.stateVersion = "23.11";
}
