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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sway-autolayout.url = "github:jakobhellermann/janet-swayipc/nix";

    niri-fork = {
      url = "github:jakobhellermann/niri/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    diffpatch = {
      url = "github:jakobhellermann/diffpatch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-darwin,
      disko,
      agenix,
      niri-fork,
      ...
    }:
    let
      # pkgs = import nixpkgs { inherit system; };
      extraSpecialArgs = { inherit inputs; };
    in
    {
      homeConfigurations = {
        minimal = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            agenix.homeManagerModules.default
            ./home/config/minimal.nix
            {
              home.username = "jakob";
              home.homeDirectory = "/home/jakob";
            }
          ];
        };
        jakob = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./home/config/nixos.nix ];
        };
        sipgatejj = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          modules = [
            agenix.homeManagerModules.default
            {
              home.username = "sipgatejj";
              home.homeDirectory = "/home/sipgatejj";
              home.stateVersion = "26.11";
            }
            ./home/config/sipgatejj.nix
          ];
        };
        sipgatejj-mac = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          modules = [
            agenix.homeManagerModules.default
            {
              home.username = "sipgatejj";
              home.homeDirectory = "/Users/sipgatejj";
            }
            ./home/config/sipgatejj-mac.nix
          ];
        };
        asahijj = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
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
          agenix.nixosModules.default
          {
            programs.niri.package = niri-fork.packages.x86_64-linux.niri;
          }
          ./nixos/hosts/sipgatejj/configuration.nix
        ];
      };
      nixosConfigurations.jj = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
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
