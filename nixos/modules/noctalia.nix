{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ libnotify ];

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
  };
}
