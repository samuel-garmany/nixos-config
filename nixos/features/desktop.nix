{self, ...}: {
  flake.nixosModules.desktop = {...}: {
    imports = [
      self.nixosModules.gtk
      self.nixosModules.qt
      self.nixosModules.fonts
      self.nixosModules.audio
      self.nixosModules.niri
      self.nixosModules.login
    ];
  };
}
