{ ... }: {
  imports = [
    ./apps/kube-prometheus-stack
    ./apps/ntfy
  ];

  services.k3s.manifests.monitoring-ns.content = {
    apiVersion = "v1";
    kind = "Namespace";
    metadata = {
      name = "monitoring";
    };
  };

  sops = {
    secrets = {
      "ntfy/domain" = { };
      "ntfy/database/host" = { };
      "ntfy/database/user" = { };
      "ntfy/database/password" = { };

      "grafana/domain" = { };
      "grafana/sso/client-id" = { };
      "grafana/sso/client-secret" = { };
      "grafana/database/host" = { };
      "grafana/database/user" = { };
      "grafana/database/password" = { };
      "grafana/alert-manager/ntfy-token" = { };
      "grafana/renderer-token" = { };
    };
  };
}
