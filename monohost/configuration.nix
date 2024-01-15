# https://github.com/nix-community/nixos-anywhere-examples/blob/37894d6ddea2beee33c7e2a9faf42d35c40c074f/configuration.nix#L1
{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-configuration.nix
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  environment.shells = [pkgs.bash pkgs.zsh];
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.neovim
  ];

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKfSXAQk+Lhsna0rD4CkeQ4T7i4LCX/LJhGvr9fGAk9 peyton@macbox"
    ];

    nixos = {
      isNormalUser = true;
      home = "/home/nixos";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKfSXAQk+Lhsna0rD4CkeQ4T7i4LCX/LJhGvr9fGAk9 peyton@macbox"
      ];
    };
  };

  services.syncthing = {
    enable = true;
    user = "nixos";
    configDir = "/home/nixos/.config/syncthing";
    dataDir = "/home/nixos/.config/syncthing/db";

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "iphone" = { id = "5YRXT5Z-KEGT5DW-VBH6EAR-YDQPFMW-LCUKH2X-QPKHWXH-BYAVZGR-LODC4AI"; };
        "crlmbp" = { id = "TGGH4PO-YTTK7W3-SDFYJNI-HPXZ5FC-SW364DR-JMQKI67-V4QFGAF-SJ6ZYQI"; };
        "macbox" = { id = "RCECRYN-BKKJI56-H5JHUMK-2DUGITH-YLWPET2-4SEMKVR-2CQ6YUA-JBTMMAW"; };
        "peytonsmbp" = { id = "UE3H5H4-TIW7NIX-7HQG4XR-QJAACS3-6NONWPQ-33CBZV5-KU5CUSM-VD2VHQR"; };
      };

      folders = {
        # generic sync folder
        "cccjw-5fcyz" = {
          path = "/home/nixos/sync";
          devices = [ "iphone" "crlmbp" "macbox" "peytonsmbp" ];
        };
      };
    };
  };

  # Save storage space
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "23.11";
}
