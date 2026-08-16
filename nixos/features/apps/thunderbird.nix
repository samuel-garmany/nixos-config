{
  flake.nixosModules.thunderbird = {
    # Config also taken from privacy guides
    programs.thunderbird = {
      enable = true;

      preferencesStatus = "default";
      preferences = {
        "mail.identity.default.reply_on_top" = 1;
        "mail.identity.default.sig_bottom" = false;
        "mail.SpellCheckBeforeSend" = true;
      };

      policies = {
        DisableTelemetry = true;

        Preferences = {
          # Remember websites and links I've visited
          # Setting this to false disables history tracking
          "places.history.enabled" = false;

          # Accept cookies from sites
          # 0 = Accept All Cookies
          # 2 = Reject all cookies (Privacy guides recommended)
          # 4 = Reject Cross-Site Tracking Cookies
          "network.cookie.cookieBehavior" = 4;
        };
      };
    };
  };
}
