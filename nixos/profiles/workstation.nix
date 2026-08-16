{self, ...}: {
  flake.nixosModules.workstation = {...}: {
    imports = [
      self.nixosModules.general

      # system
      self.nixosModules.bluetooth
      self.nixosModules.boot
      self.nixosModules.direnv
      self.nixosModules.hardware
      self.nixosModules.networking
      self.nixosModules.nixLd
      self.nixosModules.security
      self.nixosModules.tailscale
      self.nixosModules.yubikey
      self.nixosModules.powerProfilesDaemon

      # desktop
      self.nixosModules.gtk
      self.nixosModules.qt
      self.nixosModules.fonts
      self.nixosModules.audio
      self.nixosModules.geolocation
      self.nixosModules.niri
      self.nixosModules.login
      self.nixosModules.idle
      self.nixosModules.printing

      # apps
      self.nixosModules.apps
      self.nixosModules.firefox
      self.nixosModules.thunderbird
      self.nixosModules.bitwarden
      self.nixosModules.joplin
      self.nixosModules.zotero
      self.nixosModules.nextcloudClient
      self.nixosModules.neovim
      self.nixosModules.latex
      self.nixosModules.libreoffice
      self.nixosModules.nautilus
      self.nixosModules.zathura
    ];
  };
}
