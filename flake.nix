{
  description = "Peyton's nix config";

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
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin }:{
    homeConfigurations = {
      "peyton" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        modules = [
          ./homes/common.nix
          ./homes/personal.nix
          ./homes/asahi.nix
        ]; 
      };
    };

    darwinConfigurations = let
      system = "aarch64-darwin";
    in {
      "crlMBP-YV7QQ65WX2MzYw" = nix-darwin.lib.darwinSystem {
        inherit system;

        modules = [
          home-manager.darwinModules.home-manager
          ./darwin.nix
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
          ./darwin.nix
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
  };
}
