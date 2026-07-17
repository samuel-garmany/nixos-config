{
  config.hm.base = { ... }: {
    programs.bat = {
      enable = true;
    };

    home.shellAliases = {
      cat = "bat";
    };
  };
}
