{self, ...}: {
  flake.nixosModules.shared = {...}: {
    imports = [
      self.nixosModules.base
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
      self.nixosModules.firefox
      self.nixosModules.thunderbird
      self.nixosModules.bitwarden
      self.nixosModules.joplin
      self.nixosModules.zotero
      self.nixosModules.nextcloud
      self.nixosModules.neovim
      self.nixosModules.anydesk
      self.nixosModules.arduino
      self.nixosModules.audacity
      self.nixosModules.blanket
      self.nixosModules.freecad
      self.nixosModules.freetube
      self.nixosModules.gimp
      self.nixosModules.gnome-weather
      self.nixosModules.gocryptfs
      self.nixosModules.inkscape
      self.nixosModules.latex
      self.nixosModules.libreoffice
      self.nixosModules.nautilus
      self.nixosModules.obs-studio
      self.nixosModules.qalculate
      self.nixosModules.qgis
      self.nixosModules.orca-slicer
      self.nixosModules.slack
      self.nixosModules.veracrypt
      self.nixosModules.vorta
      self.nixosModules.zoom
    ];
  };
}
