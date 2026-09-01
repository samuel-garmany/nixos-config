{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    # Option descriptions quoted from wrapperModules/n/noctalia-shell/module.nix
    # in <https://github.com/BirdeeHub/nix-wrapper-modules>
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      # If you only supply `settings`, and do not choose somewhere for
      # `outOfStoreConfig` then it will only generate and set
      # `NOCTALIA_SETTINGS_FILE`
      settings = builtins.fromJSON (builtins.readFile ./settings.json);
    };
  };
}
