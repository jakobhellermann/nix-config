{ pkgs, ... }:
{
  home.packages =
    let
      devPkgs = with pkgs; [
        at-spi2-atk
        cairo
        dbus
        gdk-pixbuf
        glib
        gtk3
        harfbuzz
        libsoup_3
        libz
        pango
        webkitgtk_4_1
      ];
    in
    map (p: p.dev) devPkgs;
}
