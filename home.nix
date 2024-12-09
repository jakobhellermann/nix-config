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
  home.username = "jakob";
  home.homeDirectory = "/home/jakob";

  home.activation = {
    installDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      GIT_DIR=".dotfiles"
      WORK_TREE="."
      if [ -d "$GIT_DIR" ]; then
        $DRY_RUN_CMD git --git-dir "$GIT_DIR" --work-tree "$WORK_TREE" pull || _iError "Could not pull .dotfiles"
      else
        $DRY_RUN_CMD git --work-tree "$WORK_TREE" clone --bare https://github.com/jakobhellermann/dotfiles.git "$GIT_DIR"
        $DRY_RUN_CMD git --git-dir "$GIT_DIR" --work-tree "$WORK_TREE" checkout
        $DRY_RUN_CMD git --git-dir "$GIT_DIR" --work-tree "$WORK_TREE" config status.showUntrackedFiles no
        $DRY_RUN_CMD git --git-dir "$GIT_DIR" --work-tree "$WORK_TREE" remote set-url origin git@github.com:jakobhellermann/dotfiles.git
      fi
    '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello
    sway-autolayout

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = { };

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = null;

    systemd.enable = false;

    extraConfig = ''
      output * bg /home/jakob/Pictures/wallpapers/rotate/a.jpeg fill
      set $mod Mod1

      include config.d/keybinds/*
      include config.d/*
      include /etc/sway/config.d/*

      exec "${sway-autolayout}/bin/autolayout" > /tmp/autolayout.log
    '';
  };

  programs.home-manager.enable = true;
}
