{
  config.nixos.base = { pkgs, ... }: {
    # Enable fish system-wide
    # It is recommended to enable fish system-wide, even when using home-manager,
    # to ensure that vendor completions provided by packages in the system profile are available.
    programs.fish.enable = true;
  };

  config.hm.base = { pkgs, ... }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
      '';
    };
  };
}
