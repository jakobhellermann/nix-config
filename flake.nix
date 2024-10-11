{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }:
    {
      nixosConfigurations.sipgatejj = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
        ];
      };
      # nixosConfigurations.live = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [
      # 		./configuration.nix
      # 		(nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      #   ];
      # };
    };
}
