{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sway-autolayout.url = "github:jakobhellermann/janet-swayipc/nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      disko,
      ...
    }:
    let
      # pkgs = import nixpkgs { inherit system; };
    in
    {
      homeConfigurations = {
        jakob = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./home/config/nixos.nix ];
        };
        sipgatejj = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [
            {
              home.username = "sipgatejj";
              home.homeDirectory = "/Users/sipgatejj";
            }
            ./home/config/macos.nix
            ./home/packages/sipgate.nix
          ];
        };
        asahijj = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-linux";
          modules = [
            {
              home.username = "jakob";
              home.homeDirectory = "/home/jakob";
            }
            ./home/config/asahi.nix
          ];
        };
      };
      nixosConfigurations.sipgatejj = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./nixos/hosts/sipgatejj/configuration.nix
        ];
      };
      nixosConfigurations.jj = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/hosts/jj/configuration.nix
        ];
      };
      darwinConfigurations."sipgatejj-macos" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin/macos.nix
        ];
      };

    };
}
