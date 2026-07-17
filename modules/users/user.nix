{ config, ... }@topArgs:
{
  config.nixos.base =
    { pkgs, lib, ... }@nixosArgs:
    {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users."user" = {
        isNormalUser = true;
        description = "Samuel Garmany";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        # Set fish as the default shell for a specific user
        # Note: Using Fish as your login shell can occasionally cause issues because Fish is not POSIX-compliant.
        shell = pkgs.fish;
        packages = with pkgs; [
          #  thunderbird
        ];
      };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."user" = topArgs.config.hm.base;

      # Auto-login configuration
      # Note: getty@tty1 and autovt@tty1 are disabled to prevent a race condition
      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = "user";
      systemd.services."getty@tty1".enable = lib.mkForce false;
      systemd.services."autovt@tty1".enable = lib.mkForce false;
    };

  config.hm.base = { ... }: {
    home.stateVersion = "26.05";
  };
}
