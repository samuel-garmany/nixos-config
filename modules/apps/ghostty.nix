{
  config.hm.base = { ... }: {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "light:Gruvbox Light,dark:Gruvbox Dark";
        font-family = "Maple Mono NF";
        window-theme = "ghostty";
      };
    };
  };
}
