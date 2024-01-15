{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./asahi-hardwarecfg.nix
    ( import ../../custom/syncthing.nix { user = "peyton"; } )
  ];

  # COPY FIRMWARE FILES FROM /boot/asahi
  # 1. all_firmware.tar.gz
  # 2. kernelcache*
  hardware.asahi = {
    extractPeripheralFirmware = true;
    peripheralFirmwareDirectory = ./firmware;
    useExperimentalGPUDriver = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  networking = {
    hostName = "macbox";
    networkmanager.enable = true;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };

    firewall = { 
      enable = true;
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  nixpkgs.overlays = [
    (import ../../overlays/ollama.nix)
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "plasmawayland";
    desktopManager.plasma5.enable = true;
    libinput.enable = true;
  };

  # must manually auth with `sudo tailscale login` since I don't have a secret management solution yet
  # need to get a secret management solution going so i can use `extraUpFlags`
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  programs.ssh = {
    startAgent = true;
  };

  sound.enable = true;

  programs._1password = {
    enable = true;
  };

  # Enable the 1Passsword GUI with myself as an authorized user for polkit
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["peyton"];
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    docker-compose
  ];

  virtualisation.docker.enable = true;
}
