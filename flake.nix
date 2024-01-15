{
  description = "Peyton's nix config. 2 macOS instances, one NixOS asahi instance, one NixOS hetzner instance.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nixos-apple-silicon,
    plasma-manager,
    disko
  }: {
    darwinConfigurations = let
      system = "aarch64-darwin";
    in {
      "crlMBP-YV7QQ65WX2MzYw" = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          home-manager.darwinModules.home-manager
          ./systems/darwin.nix
          {
            users.users.peyton = {
              name = "peyton";
              home = "/Users/peyton";
            };

            home-manager.users.peyton = {
              imports = [
                ./homes/common.nix
                ./homes/crl.nix
                ./homes/darwin.nix
              ];
            };
          }
        ];
      };

      "Peytons-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          home-manager.darwinModules.home-manager
          ./systems/darwin.nix
          {
            users.users.peytonwalters = {
              name = "peytonwalters";
              home = "/Users/peytonwalters";
            };

            home-manager.users.peytonwalters = {
              imports = [
                ./homes/common.nix
                ./homes/personal.nix
                ./homes/darwin.nix
              ];
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      macbox = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixos-apple-silicon.nixosModules.apple-silicon-support
          ./systems/nixos
          ./systems/asahi
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Define a user account. Don't forget to set a password with ‘passwd’.
            users.users.peyton = {
              isNormalUser = true;
              home = "/home/peyton";
              extraGroups = [
                "wheel"
                "networkmanager"
                "docker"
              ];
            };

            home-manager.users.peyton = {
              imports = [
                plasma-manager.homeManagerModules.plasma-manager
                ./homes/common.nix
                ./homes/personal.nix
                ./homes/asahi.nix
              ];
            };
          }
        ];
        specialArgs = {
          inherit nixpkgs;
          inherit nixos-apple-silicon;
        };
      };

      # cheeky hetzner action. would love to do x86 but asahi can't build with qemu yet.
      monohost = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          ./systems/nixos
          ./systems/monohost
        ];
      };
    };
  };
}
