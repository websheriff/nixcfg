{ config, ... }: {
  sops = {
    templates = {
      "lldap/lldap-secret.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: lldap-secret
            namespace: authentication
          type: Opaque
          stringData:
            base-dn: "${config.sops.placeholder."lldap/base-dn"}"
            jwt-secret: "${config.sops.placeholder."lldap/jwt-secret"}"
            key-seed: "${config.sops.placeholder."lldap/key-seed"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/lldap-secret.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "lldap/lldap-secret-admin.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: lldap-admin
            namespace: authentication
          type: Opaque
          stringData:
            password: "${config.sops.placeholder."lldap/admin/password"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/lldap-secret-admin.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "lldap/lldap-secret-db.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: lldap-db
            namespace: authentication
          type: Opaque
          stringData:
            url: "postgres://${config.sops.placeholder."lldap/database/user"}@${
              config.sops.placeholder."lldap/database/host"
            }:5432/lldap"
            password: "${config.sops.placeholder."lldap/database/password"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/lldap-secret-db.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "lldap/lldap-database-auth.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: lldap-db-auth
            namespace: authentication
          type: Opaque
          stringData:
            username: "${config.sops.placeholder."lldap/database/user"}"
            password: "${config.sops.placeholder."lldap/database/password"}"
          type: kubernetes.io/basic-auth
        '';

        path = "/var/lib/rancher/k3s/server/manifests/lldap-database-auth.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };
    };
  };
}
