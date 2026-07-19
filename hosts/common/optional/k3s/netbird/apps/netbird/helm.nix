{ config, ... }: {
  sops.templates."netbird/netbird-operator-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: netbird-operator
        namespace: kube-system
      spec:
        chart: oci://ghcr.io/netbirdio/helm-charts/netbird-operator
        version: "0.8.0"
        targetNamespace: netbird
        createNamespace: false
        valuesContent: |
          managementURL: "https://${config.sops.placeholder."netbird/domain"}"
          
          netbirdAPI:
            keyFromSecret:
              name: "netbird-secret"
              key: "access-token"
    '';
  
    path = "/var/lib/rancher/k3s/server/manifests/netbird-operator-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
