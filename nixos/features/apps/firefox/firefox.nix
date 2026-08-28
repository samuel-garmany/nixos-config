{
  flake.nixosModules.firefox = {
    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };

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
          # Scroll speed. Status "user" so it stays adjustable in about:config.
          "mousewheel.default.delta_multiplier_y" = {
            Value = 50;
            Status = "user";
          };

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
            adminSettings = builtins.readFile ./ublock.json;
          };
        };
      };
    };
  };
}
