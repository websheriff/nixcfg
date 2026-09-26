{ config, ... }: {
  sops.templates."glauth/glauth-config.yaml" = {
    content = ''
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: glauth-config
      data:
        glauth.cfg: |
          [ldap]
            enabled = false

          [ldaps]
            enabled = true

          [backend]
            datastore = "plugin"
            plugin = "postgres.so"
            pluginhandler = "NewPostgresHandler"
            database = "${config.sops.placeholder."glauth/database/url"}"
    '';
  };
}
