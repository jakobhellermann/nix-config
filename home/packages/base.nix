{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];
  home.packages = with pkgs; [
    # bun
    # claude-code
    # docker
    bat
    bitwarden-cli
    cargo-insta
    cargo-nextest
    clang
    cmake
    comma
    direnv
    dix
    dotnet-sdk_11
    dtrx
    dust
    expect
    eza
    fastfetch
    fd
    fish-lsp
    fnm
    fzf
    gh
    go
    helix
    hicolor-icon-theme
    hyperfine
    ilspycmd
    inotify-tools
    jjui
    just
    lemminx
    lua-language-server
    mergiraf
    meson
    mold
    neovim
    ninja
    nix-index
    nix-tree
    nixd
    nixfmt
    nodejs
    nvd
    oxfmt
    p7zip
    pi-coding-agent
    pkg-config
    pnpm
    poppler-utils
    prettier
    python3
    ripgrep
    rustup
    shellcheck
    shfmt
    skim
    taplo
    tldr
    tokei
    tree-sitter
    unzip
    uv
    vtsls
    watchexec
    (lib.hiPrio wild) # conflict with clang on ld, clang has prio 10
  ];
}
