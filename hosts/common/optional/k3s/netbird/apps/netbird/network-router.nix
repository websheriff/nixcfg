{ config, ... }: {
  sops.templates."netbird/netbird-network-router.yaml" = {
    content = ''
      apiVersion: proxy.netbird.io/v1alpha1
      kind: NetworkRouter
      metadata:
        name: prod-route
        namespace: netbird
      spec:
        dnsZoneRef:
          name: ${config.sops.placeholder."admin/prod-domain"}
    '';
  };
}
