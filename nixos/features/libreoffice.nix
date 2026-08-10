{
  flake.nixosModules.libreoffice = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      libreoffice
      jre8
      hunspell
      hunspellDicts.en_US
      hyphenDicts.en_US
    ];
  };
}
