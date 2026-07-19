{
  config.hm.base = { ... }: {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  config.nixos.base = { ... }: {
    environment.extraSetup = ''
      rm -f $out/share/applications/yazi.desktop
    '';
  };
}
