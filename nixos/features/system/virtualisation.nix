{self, ...}: {
  flake.nixosModules.virtualisation = {pkgs, ...}: {
    # This option enables libvirtd, a daemon that manages virtual machines.
    # Users in the "libvirtd" group can interact with the daemon (e.g. to start
    # or stop VMs) using the virsh command line tool, among others.
    virtualisation.libvirtd.enable = true;

    # Allows libvirtd to use swtpm to create an emulated TPM.
    virtualisation.libvirtd.qemu.swtpm.enable = true;

    # Packages containing out-of-tree vhost-user drivers.
    virtualisation.libvirtd.qemu.vhostUserPackages = [pkgs.virtiofsd];

    users.users.${self.username}.extraGroups = ["libvirtd"];

    programs.virt-manager.enable = true;
  };
}
