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

    # sway-autolayout.url = "github:jakobhellermann/janet-swayipc/nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      # sway-autolayout,
      ...
    }:
    let
      # pkgs = import nixpkgs { inherit system; };
    in
    {
      homeConfigurations = {
        jakob = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            ./home/home.nix
            ./home/packages.nix
            ./home/full.nix
          ];
        };
        sipgatejj = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [
            {
              home.username = "sipgatejj";
              home.homeDirectory = "/Users/sipgatejj";
            }
            ./home/shared.nix
            ./home/macos.nix
          ];
        };
      };
      nixosConfigurations.sipgatejj = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          ./system/hardware/sipgatejj.nix
        ];
        specialArgs = {
          inputs = {
            hostname = "sipgatejj";
          };
        };
      };
      nixosConfigurations.jj = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          ./system/hardware/jj.nix
        ];
        specialArgs = {
          inputs = {
            hostname = "jj";
          };
        };
      };
      darwinConfigurations."sipgatejj-macos" = nix-darwin.lib.darwinSystem {
        modules = [ ./macos/macos.nix ];
      };
    };
}
