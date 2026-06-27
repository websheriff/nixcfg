{ inputs, config, ... }: {
  imports = [
    inputs.comin.nixosModules.comin
  ];

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = config.sops.secrets."forgejo/prod/domain".path;
        branches.main.name = "master";
      }
    ];
  };
}
