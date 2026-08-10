{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      # If you only supply `settings`, and do not choose somewhere for
      # `outOfStoreConfig` then it will only generate and set
      # `NOCTALIA_SETTINGS_FILE`
      settings = builtins.fromJSON (builtins.readFile ./noctalia-settings.json);
    };
  };
}
