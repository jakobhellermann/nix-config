{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home.activation = {
    installDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      JJ_BIN="${pkgs.jujutsu}/bin/jj --config git.executable-path=${pkgs.git}/bin/git"
      JJ_DIR=".jj"
      WORK_TREE="."
      if [ -d "$JJ_DIR" ]; then
        # $JJ_BIN git fetch
        true
      else
        tmpdir=$(mktemp -d)
        echo "$tmpdir"
        $DRY_RUN_CMD $JJ_BIN git clone --no-colocate https://github.com/jakobhellermann/dotfiles.git "$tmpdir"
        $DRY_RUN_CMD mv "$tmpdir/.jj" "$JJ_DIR"
        $DRY_RUN_CMD rm -fr "$tmpdir"
        $JJ_BIN config set --repo snapshot.auto-track 'none()'
        echo '*' > "$JJ_DIR/repo/store/git/info/exclude"
      fi
    '';
  };

  programs.git.enable = true;

  home.packages = with pkgs; [
    clang
    cmake
    comma
    dust
    expect
    eza
    fd
    fzf
    gh
    nvd
    go
    hyperfine
    jujutsu
    just
    meson
    mold
    neovim
    ninja
    nixd
    nixfmt-rfc-style
    python3
    ripgrep
    rustup
    watchexec
  ];

  home.stateVersion = "24.11";
}
