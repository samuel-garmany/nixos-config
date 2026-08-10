{self, ...}: {
  # Single source of truth: the NixOS account below and any wrapped package that
  # needs a path under /home (see wrappedPrograms/noctalia.nix) read this.
  flake.username = "user";
  flake.fullName = "Samuel Garmany";
  flake.email = "65299214+samuel-garmany@users.noreply.github.com";

  flake.nixosModules.base = {lib, ...}: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = self.username;
      };
    };
  };
}
