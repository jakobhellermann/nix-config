default:
    just --unsorted --list

update:
    nix flake update

nixos:
    sudo nixos-rebuild switch --flake .

darwin:
    sudo darwin-rebuild switch --flake .

home profile=`whoami`:
    nix run nixpkgs#home-manager -- switch --flake .#{{ profile }}

agenix name:
    @cd secrets && nix run github:ryantm/agenix -- -e "{{ name }}.age"

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

preview-home inputs="nixpkgs": (_preview "homeConfigurations.$(whoami).activationPackage" '$HOME/.local/state/nix/profiles/home-manager' inputs)

preview-nixos inputs="nixpkgs": (_preview "nixosConfigurations.$(hostname).config.system.build.toplevel" "/run/current-system" inputs)

[private]
_preview attr old inputs="nixpkgs":
    #!/usr/bin/env bash
    set -euo pipefail
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    rsync -a --exclude .git --exclude result ./ "$tmp/"
    cd "$tmp"
    if [ "{{ inputs }}" = all ]; then
        nix flake update
    else
        nix flake update {{ inputs }}
    fi
    old=$(readlink -f {{ old }})
    new=$(nix build ".#{{ attr }}" --no-link --print-out-paths)
    nix run nixpkgs#dix -- "$old" "$new"
