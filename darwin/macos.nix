{
  pkgs,
  ...
}:
let
  user = "sipgatejj";
in
{
  nix.settings.experimental-features = "nix-command flakes";

  system.primaryUser = user;
  users.users.${user} = {
    shell = pkgs.fish;
  };

  environment.shells = [ pkgs.fish ];
  environment.systemPackages = [ ];

  programs.fish.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (_self: super: {
      fish = super.fish.overrideAttrs {
        doCheck = false;
      };
    })
  ];

  homebrew.enable = true;
  homebrew.casks = [
    "discord"
    "ghostty"
    "swift-shift"
    "zed"
    "zen"
    "raycast"
  ];

  system.defaults.CustomUserPreferences = {
  };

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 6;
}
