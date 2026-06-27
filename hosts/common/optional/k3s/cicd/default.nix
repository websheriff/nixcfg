{ ... }: {

  imports = [
    ./apps/forgejo
    #./apps/forgejo-runner
  ];

  services.k3s.manifests.cicd-ns.content = {
    apiVersion = "v1";
    kind = "Namespace";
    metadata = {
      name = "cicd";
    };
  };

  sops = {
    secrets."forgejo/prod/domain" = { };
    secrets."forgejo/admin/user" = { };
    secrets."forgejo/admin/password" = { };
    secrets."forgejo/prod/database/host" = { };
    secrets."forgejo/prod/database/user" = { };
    secrets."forgejo/prod/database/password" = { };
    secrets."forgejo/prod/oauth/client-id" = { };
    secrets."forgejo/prod/oauth/client-secret" = { };
    secrets."forgejo/prod/runner/token" = { };
  };
}
