{ config, pkgs, ... }:

{
  # Include the results of the hardware scan.
  imports = [ ./asahi-hardwarecfg.nix ];

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
    (import ../overlays/ollama.nix)
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  environment.shells = [pkgs.bash pkgs.zsh];
  users.defaultUserShell = pkgs.zsh;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "plasmawayland";
    desktopManager.plasma5.enable = true;
    libinput.enable = true;
  };

  services.syncthing = {
    enable = true;
    user = "peyton";
    configDir = "/home/peyton/.config/syncthing";
    dataDir = "/home/peyton/.config/syncthing/db";

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        "iphone" = { id = "5YRXT5Z-KEGT5DW-VBH6EAR-YDQPFMW-LCUKH2X-QPKHWXH-BYAVZGR-LODC4AI"; };
        "crlmbp" = { id = "TGGH4PO-YTTK7W3-SDFYJNI-HPXZ5FC-SW364DR-JMQKI67-V4QFGAF-SJ6ZYQI"; };
      };

      folders = {
        # generic sync folder
        "cccjw-5fcyz" = {
          path = "/home/peyton/sync";
          devices = [ "iphone" "crlmbp" ];
        };
      };
    };
  };

  programs.ssh = {
    startAgent = true;
  };

  # Save storage space
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
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
    git
    neovim
    wget
    lshw
    wl-clipboard
    docker-compose
  ];

  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
