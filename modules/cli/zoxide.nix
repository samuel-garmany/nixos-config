{
  config.hm.base = { ... }: {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
