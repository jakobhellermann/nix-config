{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sway-autolayout.url = "github:jakobhellermann/janet-swayipc/nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sway-autolayout,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      homeConfigurations = {
        jakob = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit system;
            inputs = {
              inherit sway-autolayout;
            };
          };
          modules = [
            ./home/home.nix
            ./home/packages.nix
            ./home/full.nix
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
    };
}
