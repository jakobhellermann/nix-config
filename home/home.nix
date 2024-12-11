{
  pkgs,
  system,
  inputs,
  lib,
  ...
}:
let
  sway-autolayout = inputs.sway-autolayout.packages.${system}.default;
in
{
  nixpkgs.config.allowUnfree = true;

  home.username = "jakob";
  home.homeDirectory = "/home/jakob";

  home.activation = {
    installDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      GIT_BIN=${pkgs.git}/bin/git
      GIT_DIR=".dotfiles"
      WORK_TREE="."
      if [ -d "$GIT_DIR" ]; then
        $DRY_RUN_CMD $GIT_BIN --git-dir "$GIT_DIR" --work-tree "$WORK_TREE" pull || _iError "Could not pull .dotfiles"
      else
        $DRY_RUN_CMD $GIT_BIN --work-tree "$WORK_TREE" clone --bare https://github.com/jakobhellermann/dotfiles.git "$GIT_DIR"
        $DRY_RUN_CMD $GIT_BIN --git-dir "$GIT_DIR" --work-tree "$WORK_TREE" checkout
        $DRY_RUN_CMD $GIT_BIN --git-dir "$GIT_DIR" --work-tree "$WORK_TREE" config status.showUntrackedFiles no
        $DRY_RUN_CMD $GIT_BIN --git-dir "$GIT_DIR" --work-tree "$WORK_TREE" remote set-url origin git@github.com:jakobhellermann/dotfiles.git
      fi
    '';
  };

  home.packages = [ sway-autolayout ];

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = null;

    systemd.enable = false;

    extraConfig = ''
      set $mod Mod1

      include config.d/keybinds/*
      include config.d/*
      include /etc/sway/config.d/*

      # exec "${sway-autolayout}/bin/autolayout" > /tmp/autolayout.log
    '';
  };
  services.swayosd.enable = true;

  programs.home-manager.enable = true;
  # programs.zsh.oh-my-zsh = {
  #   enable = true;
  # };
  # programs.neovim = {
  #   enable = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  # };

  # services.swayosd.enable = true;

  home.stateVersion = "24.11";
}
