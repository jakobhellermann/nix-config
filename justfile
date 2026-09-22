default:
    just --unsorted --list

update:
    nix flake update

nixos:
    sudo nixos-rebuild switch --flake .

darwin:
    sudo darwin-rebuild switch --flake .

home:
    nix run nixpkgs#home-manager -- switch --flake .

provision host configuration:
    nix run github:nix-community/nixos-anywhere -- --flake .#{{ configuration }} {{ host }}

build-vm configuration="sipgatejj":
    nix build .#nixosConfigurations.{{ configuration }}.config.system.build.vm

run-vm configuration="sipgatejj": build-vm
    ./result/bin/run-{{ configuration }}-vm

build-iso:
    nix build .#nixosConfigurations.live.config.system.build.isoImage

diff:
    @unbuffer dix $(nix run nixpkgs#home-manager generations | head -n2 | cut -d' ' -f7 | tac) | tail -n +3
