{ pkgs, ... }:
{
  programs.steam.enable = true;
  # share host /tmp so steam-run games can use /tmp-based IPC with host processes
  programs.steam.package = pkgs.steam.override { privateTmp = false; };
}
