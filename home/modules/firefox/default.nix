{
  programs.firefox = {
    enable = true;

    policies = {
      # All options: https://mozilla.github.io/policy-templates/#preferences
      Preferences = {
        "browser.newtabpage.activity-stream.feeds.topsites".Value = false;
        "browser.newtabpage.activity-stream.feeds.weatherfeed".Value = false;
        "browser.fixup.domainsuffixwhitelist.home".Value = true; # treat .home as TLD
        "general.autoScroll".Value = true; # middle-click to scroll
      };

      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest";
        };
        # Vimium
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest";
        };
      };
    };
  };
}
