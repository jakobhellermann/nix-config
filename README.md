# nix-config

```sh
git clone https://github.com/jakobhellermann/nix-config

mkdir .config/nix
echo 'experimental-features = nix-command flakes' > .config/nix/nix.conf
```

## Extra steps on arch linux
```sh
usermod -aG nix-users jakob
systemctl enable --now nix-daemon

nix run nixpkgs#paru -- -S paru
```
