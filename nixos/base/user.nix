{lib, ...}: {
  options.flake = {
    username = lib.mkOption {
      type = lib.types.str;
    };

    fullName = lib.mkOption {
      type = lib.types.str;
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config.flake = {
    username = "user";
    fullName = "Samuel Garmany";

    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8Oq+mVW8+eKyLtpefLdnkAMRrmVeVDfotlYfdGhs74 user@secureblue"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpe5YfySlIVBJjc2vm/sQ29JYLi3nD/kdOY+9NyNMZu user@desktop"
    ];
  };
}
