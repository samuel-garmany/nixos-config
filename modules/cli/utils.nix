{
  config.hm.base = { pkgs, ... }: {
    home.packages = with pkgs; [
      fd
      ripgrep
      jq
      tldr
    ];
  };
}
