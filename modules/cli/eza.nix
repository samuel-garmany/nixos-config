{
  config.hm.base = { ... }: {
    programs.eza = {
      enable = true;
      enableFishIntegration = true;
    };

    home.shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
    };
  };
}
