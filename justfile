build-vm configuration="sipgatejj":
	nix build .#nixosConfigurations.sipgatejj.config.system.build.vm

run-vm configuration="sipgatejj": build-vm
	./result/bin/run-sipgatejj-vm

build-iso:
	nix build .#nixosConfigurations.live.config.system.build.isoImage
