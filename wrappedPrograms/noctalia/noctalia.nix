{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    checks.noctalia-pam-service = pkgs.runCommand "noctalia-pam-service" {} ''
      grep -q NOCTALIA_PAM_SERVICE ${config.packages.noctalia-shell}/share/noctalia-shell/Modules/LockScreen/LockContext.qml
      touch $out
    '';

    # Option descriptions quoted from wrapperModules/n/noctalia-shell/module.nix
    # in <https://github.com/BirdeeHub/nix-wrapper-modules>
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      # If you only supply `settings`, and do not choose somewhere for
      # `outOfStoreConfig` then it will only generate and set
      # `NOCTALIA_SETTINGS_FILE`
      settings = builtins.fromJSON (builtins.readFile ./settings.json);

      env.NOCTALIA_PAM_SERVICE = "noctalia";
    };
  };
}
