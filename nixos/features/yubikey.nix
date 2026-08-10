{
  flake.nixosModules.yubikey = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.yubioath-flutter
    ];

    services.udev.packages = [pkgs.yubikey-personalization];
    services.pcscd.enable = true;
  };
}
