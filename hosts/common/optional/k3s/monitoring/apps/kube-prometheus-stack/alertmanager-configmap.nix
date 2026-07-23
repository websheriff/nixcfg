{ ... }: {
  services.k3s.manifests.alertmanager-ntfy-configmap.content = {
    apiVersion = "v1";
    kind = "ConfigMap";
    metadata = {
      name = "alertmanager-ntfy-config";
      namespace = "monitoring";
    };
    data = {
      "config.yml" = ''
        http:
          addr: ":5000"
        ntfy:
          notification:
            topic: alertmanager
            priority: |
              status == "firing" ? "urgent" : "default"
            tags:
              - tag: "+1"
                condition: status == "resolved"
              - tag: rotating_light
                condition: status == "firing"
        templates:
          title: |
            {{ if eq .Status "resolved"}}Resolved: {{ end }}{{ index .Annotations "summary"}}
          description: |
            {{ index .Annotations "description" }}
          headers:
            X-Click: |
              {{ .GeneratorURL }}
      '';
    };
  };
}
