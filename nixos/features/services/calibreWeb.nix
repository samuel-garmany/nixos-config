{
  flake.nixosModules.calibreWeb = {...}: {
    services.calibre-web = {
      enable = true;

      # IP address that Calibre-Web should listen on.
      listen.ip = "127.0.0.1";

      options = {
        calibreLibrary = "/mnt/data/calibre-web";
        enableBookUploading = true;
        enableKepubify = true;
      };
    };
  };
}
