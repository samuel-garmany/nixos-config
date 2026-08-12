{inputs, ...}: {
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      wrappersModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };

      username = inputs.nixpkgs.lib.mkOption {
        default = "";
      };

      fullName = inputs.nixpkgs.lib.mkOption {
        default = "";
      };

      email = inputs.nixpkgs.lib.mkOption {
        default = "";
      };
    };
  };

  config = {
    systems = [
      "x86_64-linux"
    ];

    perSystem = {system, ...}: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  };
}
