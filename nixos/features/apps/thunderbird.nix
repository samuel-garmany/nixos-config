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

        "mail.accounthub.manualconfig.enabled" = true;
        "calendar.dialogs.new.enabled" = true;
        "calendar.item.editInTab" = true;
        "calendar.extract.service.enabled" = true;
        "mail.compose.add_link_preview" = true;
        "mailnews.start_page.enabled" = false;
      };

      policies = {
        DisableTelemetry = true;

        InAppNotification.Disabled = true;

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
