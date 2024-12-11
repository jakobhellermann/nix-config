{
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    #   firefox
    #   bitwarden-desktop
    #   signal-desktop
    #   fuzzel
    #   waybar
    #   nixfmt-rfc-style
    #   signal-desktop
    #   watchexec
    #   just
    #   discord
    #   spotify
    #   vscode
    hello

    #   sway-autolayout

    #   # (pkgs.writeShellScriptBin "my-hello" ''
    #   #   echo "Hello, ${config.home.username}!"
    #   # '')
  ];
}
