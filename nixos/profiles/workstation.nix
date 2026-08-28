{self, ...}: {
  flake.nixosModules.workstation = {
    imports = [
      self.nixosModules.general

      # system
      self.nixosModules.appimage
      self.nixosModules.bluetooth
      self.nixosModules.boot
      self.nixosModules.direnv
      self.nixosModules.hardware
      self.nixosModules.networking
      self.nixosModules.nixLd
      self.nixosModules.powerProfilesDaemon
      self.nixosModules.security
      self.nixosModules.tailscale
      self.nixosModules.yubikey

      # desktop
      self.nixosModules.audio
      self.nixosModules.fonts
      self.nixosModules.geolocation
      self.nixosModules.gnome
      self.nixosModules.printing
      self.nixosModules.qt

      # apps
      self.nixosModules.apps
      self.nixosModules.bitwarden
      self.nixosModules.brave-origin
      self.nixosModules.chemistry
      self.nixosModules.fabrication
      self.nixosModules.firefox
      self.nixosModules.joplin
      self.nixosModules.typesetting
      self.nixosModules.libreoffice
      self.nixosModules.nautilus
      self.nixosModules.neovim
      self.nixosModules.nextcloudClient
      self.nixosModules.terminal
      self.nixosModules.thunderbird
      self.nixosModules.zathura
      self.nixosModules.zotero
    ];
  };
}
