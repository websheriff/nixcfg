{ ... }: {
  sops.templates."forgejo/forgejo-runner-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: forgejo-runner
        namespace: kube-system
      spec:
        repo: oci://code.forgejo.org/forgejo-helm/forgejo/forgejo-runner
        version: "0.7.5"
        targetNamespace: cicd
        createNamespace: false
        valuesContent: |
          runner:
            config:
              create: false
              existingInitSecret: "forgejo-runner-secret-init"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/forgejo-runner-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
