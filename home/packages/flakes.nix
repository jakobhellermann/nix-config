{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.diffpatch.packages.${pkgs.system}.default

    # extraPolicies is a wrapFirefox arg, not reachable via .override on the flake package;
    # the wrapper discards the policies baked into zen-browser-unwrapped, hence DisableAppUpdate here
    (pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped {
      pname = "zen-browser";
      # the Preferences policy allowlist rejects non-Firefox pref prefixes
      extraPrefs = ''
        pref("zen.window-sync.enabled", false);
      '';
      extraPolicies = (import ../modules/firefox/policies.nix) // {
        DisableAppUpdate = true;
      };
    })
  ];
}
