{ lib, pkgs, ... }:
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
        libx11
        libxcb
        libz
        pango
        SDL2
        sdl3
        webkitgtk_4_1
      ];
    in
    (map (p: p.out) devPkgs)
    ++ (map (p: p.dev) devPkgs)
    ++ (with pkgs; [
      # protocol headers win over the stale copies bundled in libx11.dev
      (lib.hiPrio xorgproto.out)
      # sdl3 splits into out/lib/dev; the libSDL3.so linker symlink lives in lib
      sdl3.lib
      vulkan-headers
      vulkan-loader
    ]);
}
