{self, ...}: {
  flake.nixosModules.borgbackup = {
    # Serve BorgBackup repositories to given public SSH keys, restricting their
    # access to the repository only. Clients do not need to specify the absolute
    # path when accessing the repository, i.e. `user@machine:.` is enough.
    services.borgbackup.repos.borgbackup = {
      # Where to store the backups. Note that the directory is created
      # automatically, with correct permissions.
      path = "/mnt/data/borgbackup";

      # Public SSH keys that are given full write access to this repository.
      inherit (self) authorizedKeys;

      # Allow clients to create repositories in subdirectories of the specified
      # path. These can be accessed using `user@machine:path/to/subrepo`.
      allowSubRepos = true;
    };
  };
}
