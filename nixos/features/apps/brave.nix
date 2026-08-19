{
  # Enable policies for chromium based browsers like Chromium, Google Chrome or Brave
  flake.nixosModules.brave = {pkgs, ...}: {
    environment.systemPackages = [
      (pkgs.brave.override {
        commandLineArgs = "--ozone-platform-hint=auto";
      })
    ];

    programs.chromium = {
      enable = true;

      # List of chromium extensions to install.
      extensions = [
        "gfolddmfcichcfnghdchbfgpmgodmkjd" # Proctorio Secure Exam Proctor
      ];

      extraOpts = {
        MetricsReportingEnabled = false;
      };
    };
  };
}
