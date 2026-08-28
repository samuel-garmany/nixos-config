{
  flake.nixosModules.locale = {
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # en_DK is English with ISO 8601 dates and 24-hour time.
    i18n.extraLocaleSettings.LC_TIME = "en_DK.UTF-8";

    i18n.supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
    ];
  };
}
