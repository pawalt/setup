{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-configuration.nix
    ( import ../../custom/syncthing.nix { user = "nixos"; } )
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;

  networking.hostName = "monohost";

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

  # must manually auth with `sudo tailscale login` since I don't have a secret management solution yet
  # need to get a secret management solution going so i can use `extraUpFlags`
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
}
