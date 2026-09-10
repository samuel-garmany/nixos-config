{inputs, ...}: {
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  config = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    perSystem = {
      pkgs,
      system,
      ...
    }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # A package used by `nix fmt`.
      formatter = pkgs.alejandra;
    };
  };
}
