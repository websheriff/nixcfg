{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.optional.services.forgejo;
in
let
  forgecfg = config.services.forgejo;
  srv = forgecfg.settings.server;
in {
  options.optional.services.caddy.enable = mkEnableOption "enable forgejo";
  config = mkIf cfg.enable {

    services.caddy = {
      virtualHosts."${config.sops.sercrets."forgejo/dev/domain".path}
        services.caddy = {
          virtualHosts."${config.sops.sercrets."forgejo/dev/domain".path}".extraConfig = ''
          reverse_proxy http://localhost:3000

         tls /var/lib/acme/${config.sops.secrets."admin/dev-domain".path}/cert.pem /var/lib/acme/${config.sops.secrets."admin/dev-domain"}.path/key.pem {
            protocols tls1.3
          }
        '';
        };"
          .extraConfig = ''
        reverse_proxy http://localhost:3000

        tls /var/lib/acme/${config.sops.secrets."admin/dev-domain".path}/cert.pem /var/lib/acme/${config.sops.secrets."admin/dev-domain".path}/key.pem {
          protocols tls1.3
        }
      '';
    };
    
    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "${config.sops.secrets."forgejo/dev/domain".path}";
          ROOT_URL = "https://${srv.DOMAIN}/";
          HTTP_PORT = 3000;
        };

        service.DISABLE_REGISTRATION = true;

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };

        mailer = {
          ENABLED = false;
        };
      };
    };
  
    services = {
      forgejo.settings.server.SSH_PORT = lib.head config.services.openssh.ports;
    };

    #services.gitea-actions-runner = {
      #package = pkgs.forgejo-runner;
      #instances.default = {
        #enable = true;
        #name = "";
        #url = "https://${config.sops.secrets."forgego/dev/domain".path}";
        #tokenFile = ;
        #label = [
          #"native:host"
        #];
      #};
    #};
}
