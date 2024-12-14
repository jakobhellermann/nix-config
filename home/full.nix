{
  pkgs,
  system,
  inputs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [ dconf ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    enable = true;
    # theme = {
    #   name = "orchis-theme";
    #   package = pkgs.orchis-theme;
    # };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  home.sessionVariables = rec {
    JANET_TREE = "$HOME/.local/jpm_tree";
    JANET_HEADERPATH = "${pkgs.janet}/include/janet";
    JANET_PATH = "${JANET_TREE}/lib";
    JANET_LIBPATH = "${pkgs.janet}/lib";
  };
  home.sessionPath = [ "$HOME/.local/jpm_tree/bin" ];

  home.stateVersion = "24.11";
}
