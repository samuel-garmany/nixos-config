{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        hunspell
        hunspellDicts.en_US
        hyphenDicts.en_US
        jre8
        libreoffice
      ];
    };
}
