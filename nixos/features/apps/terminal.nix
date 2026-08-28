{
  flake.nixosModules.terminal = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.ptyxis
    ];

    programs.dconf.profiles.user.databases = [
      {
        lockAll = false;
        settings."org/gnome/Ptyxis".interface-style = "system";
      }
    ];
  };
}
