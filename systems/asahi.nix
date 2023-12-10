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
  };

  nixpkgs.config.allowUnfree = true;
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
      };

      folders = {
        # generic sync folder
        "cccjw-5fcyz" = {
          path = "/home/peyton/sync";
          devices = [ "iphone" ];
        };
      };
    };
  };

  programs.ssh = {
    startAgent = true;
  };

  # Enable sound. no speakers tho lol
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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
  ];

  system.stateVersion = "23.11";
}
