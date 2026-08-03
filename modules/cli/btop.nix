{
  config.hm.base = { ... }: {
    programs.btop = {
      enable = true;
    };
  };

  config.nixos.base = { ... }: {
    environment.extraSetup = ''
      rm -f $out/share/applications/btop.desktop
    '';
  };
}
