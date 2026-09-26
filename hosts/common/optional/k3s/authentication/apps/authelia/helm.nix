{ config, ... }: {
  sops.templates."authelia/authelia-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: authelia
        namespace: kube-system
      spec:
        repo: https://charts.authelia.com
        chart: authelia
        version: "0.11.6"
        targetNamespace: authentication
        createNamespace: false
        valuesContent: |
          configMap:
            session:
              cookies: "${config.sops.placeholder."authelia/domain"}"
            storage:
              postgres:
                enabled: true
                address:
                
            authentication_backend:
              ldap:
                enabled: true
                implementation: "lldap"
                address: "${config.sops.placeeholder."lldap/domain"}"
                base_dn: "DC=002042,DC=xyz"
                user: "UID=authelia,OU=people,DC=002042,DC=xyz"
                password:
                  secret_name: lldap
                  value: password
    '';

    path = "/var/lib/rancher/k3s/server/manifests/authelia-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
