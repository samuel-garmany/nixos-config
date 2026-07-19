{
  config.hm.base = { ... }: {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_dark";
      };
    };
  };

  config.nixos.base = { ... }: {
    environment.extraSetup = ''
      rm -f $out/share/applications/btop.desktop
    '';
  };
}
