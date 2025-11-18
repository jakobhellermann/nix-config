default:
	just --unsorted --list

update:
    nix flake update

home:
    nix run nixpkgs#home-manager -- switch --flake .

system:
    sudo nixos-rebuild switch --flake .

darwin:
    sudo darwin-rebuild switch --flake .

full: home system

build-vm configuration="sipgatejj":
	nix build .#nixosConfigurations.sipgatejj.config.system.build.vm

run-vm configuration="sipgatejj": build-vm
	./result/bin/run-sipgatejj-vm

build-iso:
	nix build .#nixosConfigurations.live.config.system.build.isoImage
