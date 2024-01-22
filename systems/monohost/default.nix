{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-configuration.nix
    ( import ../../custom/user-specific.nix { user = "nixos"; inherit config; } )
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  services.fail2ban.enable = true;

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

  age.secrets.monohost_tskey.file = ../../secrets/monohost_tskey.age;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";

    authKeyFile = config.age.secrets.monohost_tskey.path;

    extraUpFlags = [
      "--accept-routes"
    ];
  };
}
