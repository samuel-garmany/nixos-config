{
  flake.nixosModules.firefox = {
    # Install firefox.
    # Settings are pulled from privacyguides
    programs.firefox = {
      enable = true;
      policies = {
        # Telemetry & Studies
        DisableTelemetry = true;
        DisableFirefoxStudies = true;

        PasswordManagerEnabled = false;

        SearchEngines = {
          Default = "Brave";
          Add = [
            {
              Name = "Brave";
              URLTemplate = "https://search.brave.com/search?q={searchTerms}";
              Method = "GET";
            }
          ];
        };

        # SanitizeOnShutdown = {
        #   Cache = true;
        #   Cookies = true;
        #   Downloads = true;
        #   FormData = true;
        #   History = false; # Example: Keep history, clear everything else
        #   Sessions = true;
        #   SiteSettings = false;
        #   OfflineApps = true;
        #   Locked = true; # Prevents changing this setting in the Firefox UI
        # };
        Preferences = {
          # Vertical Tabs
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "expand-on-hover";

          # Restore session
          "browser.startup.page" = 3;

          # Search Suggestions
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;

          # Sponsored Content
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # Enhanced Tracking Protection
          "browser.contentblocking.category" = "strict";

          # Telemetry
          "datareporting.policy.dataSubmissionEnabled" = false;
          "browser.discovery.enabled" = false;

          # Website Advertising Preferences
          "dom.private-attribution.submission.enabled" = false;

          # HTTPS-Only Mode
          "dom.security.https_only_mode" = true;

          # DNS over HTTPS
          #"network.trr.mode" = 3;
          #"network.trr.uri" = "https://dns.quad9.net/dns-query";
        };

        ExtensionSettings = {
          # Block all extensions by default
          "*".installation_mode = "blocked";

          # Allow and install specific extensions by their GUID
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };

          "@testpilot-containers" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        "3rdparty".Extensions = {
          "uBlock0@raymondhill.net" = {
            adminSettings = builtins.toJSON {
              userSettings = {
                advancedUserEnabled = true;
              };

              # Example configuration with exceptions:
              # (Note: 'noop' overrides the global block and falls back to standard filter lists, which is the safest way to unbreak sites)
              #
              # dynamicFilteringString = ''
              #   * * 3p-script block
              #   * * 3p-frame block
              #
              #   # Exception: allow all 3rd-party scripts to run on nixos.org
              #   nixos.org * 3p-script noop
              #
              #   # Exception: allow scripts from a specific domain (like github.com) to run on nixos.org
              #   nixos.org github.com * noop
              # '';

              dynamicFilteringString = ''
                * * 3p-script block
                * * 3p-frame block
                canvas.colorado.edu * 3p-script noop
                canvas.colorado.edu * 3p-frame noop
                github.com * 3p-frame noop
                github.com * 3p-script noop
              '';
            };
          };
        };
      };
    };
  };
}
