{ lib, pkgs, ... }:
{
  imports = [
    ./packages/base.nix
  ];

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

  home.stateVersion = "24.11";
}
