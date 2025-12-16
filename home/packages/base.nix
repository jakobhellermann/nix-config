{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];
  home.packages = with pkgs; [
    clang
    claude-code
    cmake
    comma
    dix
    dust
    expect
    eza
    fastfetch
    fd
    fzf
    gh
    go
    helix
    hicolor-icon-theme
    hyperfine
    jujutsu
    just
    mergiraf
    meson
    mold
    neovim
    ninja
    nix-tree
    nixd
    nixfmt-rfc-style
    nvd
    python3
    ripgrep
    rustup
    tokei
    watchexec
  ];
}
