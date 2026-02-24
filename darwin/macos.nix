{
  pkgs,
  ...
}:
let
  user = "sipgatejj";
in
{
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [
    "root"
    user
  ];
  nix.settings.warn-dirty = false;

  nix.linux-builder.enable = true;

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
  homebrew.brews = [
    "colima"
  ];
  homebrew.casks = [
    "discord"
    "ghostty"
    "swift-shift"
    "zed@preview"
    "zen"
    "raycast"
  ];

  system.defaults = {
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1; # tap to click
    WindowManager.EnableStandardClickToShowDesktop = false;
    dock.show-recents = false;

    CustomUserPreferences = { };
  };

  services.skhd = {
    enable = true;
    skhdConfig =
      let
        toggleTelephone = pkgs.writeScript "toggle-telephone" ''
          #!/usr/bin/osascript
          tell application "System Events"
            if frontmost of process "Telephone" then
              set visible of process "Telephone" to false
            else
              tell application "Telephone" to activate
            end if
          end tell
        '';
      in
      ''
        cmd + alt - t : ${toggleTelephone}
      '';
  };

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 6;
}
