{ config, ... }: {
  sops.templates."netbird/netbird-operator-helm" = {
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
          managementURL: "${config.sops.placeholder."netbird/domain"}"
          
          netbirdAPI:
            keyFromSecret:
              name: "netbird-secret"
              key: "access-token"
    '';
  
    path = "/var/lib/rancher/k3s/server/manifests/netbird-operator-helm";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
