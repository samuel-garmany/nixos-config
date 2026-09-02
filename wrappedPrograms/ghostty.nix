{
  self,
  inputs,
  ...
}: {
  # Configuration of ghostty.
  # See ghostty(5) or <https://ghostty.org/docs/config/reference>
  flake.wrappersModules.ghostty = _: {
    config.settings = {
      config-file = "?~/.config/ghostty/themes/noctalia";
      window-padding-balance = true;
    };
  };

  perSystem = {pkgs, ...}: {
    packages.terminal =
      (inputs.wrappers.wrapperModules.ghostty.apply {
        inherit pkgs;
        imports = [self.wrappersModules.ghostty];
      }).wrapper;
  };
}
