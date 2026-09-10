{
  flake.wrappers.terminal = {wlib, ...}: {
    imports = [wlib.wrapperModules.ghostty];

    # Configuration of ghostty.
    # See ghostty(5) or <https://ghostty.org/docs/config/reference>
    settings = {
      config-file = "?~/.config/ghostty/themes/noctalia";
      window-padding-balance = true;
    };
  };
}
