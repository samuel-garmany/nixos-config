{
  flake.nixosModules.calibre-web = {...}: {
    services.calibre-web = {
      enable = true;

      options = {
        calibreLibrary = "/mnt/data/calibre-web";
        enableBookUploading = true;
        enableKepubify = true;
      };
    };
  };
}
