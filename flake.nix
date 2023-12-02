{
  description = "Peyton's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:{
    packages.aarch64-linux.hello = nixpkgs.legacyPackages.aarch64-linux.hello;
    packages.aarch64-linux.default = self.packages.aarch64-linux.hello;

    homeConfigurations = {
      "peyton" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        modules = [
          ./home.nix
        ]; 
      };
    };
  };
}
