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
    perf
    ripgrep
    sd
    wev
    wget
    xxd
  ];
}
