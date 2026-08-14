{self, ...}: {
  flake.nixosModules.shared = {...}: {
    imports = [
      self.nixosModules.general

      # system
      self.nixosModules.bluetooth
      self.nixosModules.boot
      self.nixosModules.hardware
      self.nixosModules.locale
      self.nixosModules.networking
      self.nixosModules.security
      self.nixosModules.tailscale
      self.nixosModules.yubikey
      self.nixosModules.power-profiles-daemon

      # desktop
      self.nixosModules.desktop
      self.nixosModules.idle
      self.nixosModules.printing

      # apps
      self.nixosModules.apps
      self.nixosModules.firefox
      self.nixosModules.thunderbird
      self.nixosModules.bitwarden
      self.nixosModules.joplin
      self.nixosModules.zotero
      self.nixosModules.nextcloud
      self.nixosModules.neovim
      self.nixosModules.latex
      self.nixosModules.libreoffice
      self.nixosModules.nautilus
      self.nixosModules.zathura
    ];
  };
}
