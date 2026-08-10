{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    # Option descriptions quoted from wrapperModules/n/noctalia-shell/module.nix
    # in <https://github.com/BirdeeHub/nix-wrapper-modules>
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      # Regenerate this file from the running shell. `dump-noctalia-shell`
      # prints the same state as nix code instead.
      #   noctalia-shell ipc call state all | jq .settings > noctalia-settings.json
      settings = builtins.fromJSON (builtins.readFile ./noctalia-settings.json);

      # If provided, creates a copy script which copies the generated
      # configuration to this location.
      #
      # Any files existing in that location will NOT be overridden.
      outOfStoreConfig = "/home/${self.username}/.config/noctalia";
    };
  };
}
