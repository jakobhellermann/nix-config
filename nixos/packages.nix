{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    acpi
    curl
    dig
    fd
    file
    gdb
    git
    htop
    jq
    jujutsu
    lsof
    neovim
    ripgrep
    sd
    wev
    wget
  ];
}
