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
    man-pages
    man-pages-posix
    neovim
    perf
    ripgrep
    sd
    wev
    wget
    (pkgs.callPackage ./pkgs/perfetto-tools { })
    xxd
  ];
}
