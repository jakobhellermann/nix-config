{ pkgs, lib, ... }:

let
  pname = "cogfly";
  version = "1.2.5";

  src = pkgs.fetchurl {
    url = "https://github.com/Nix-main/Cogfly/releases/download/${version}/Cogfly-${version}.AppImage";
    sha256 = "sha256-oshbgAemmiulG2q3hWf50FuOZsyIH4Lj166mnxRk4xI=";
  };

  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/Cogfly.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/icon.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=Cogfly %u' 'Exec=${pname} %u' \
      --replace-fail 'Icon=icon' 'Icon=${pname}'
  '';

  meta = with lib; {
    description = "Cross-platform mod manager and mod installer for Hollow Knight: Silksong";
    homepage = "https://github.com/nix-main/cogfly";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
