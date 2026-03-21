{ config, pkgs, ... }:
with lib; let
  cfg =
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "${config.sops.secrets."admin/email".path}";
    defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

    certs."${config.sops.secrets."admin/dev-domain".path}" = {
      group = config.services.caddy.group;

      domain = "${config.sops.secrets."admin/dev-domain".path}";
      extraDomainNames = [ "*.${config.sops.secrets."admin/dev-domain".path}" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = "${pkgs.writeText} "cloudflare-creds" ''
        CLOUDFLARE_DNS_API_TOKEN=${config.sops.secrets."admin/cloudflare-api"}
      ''}";     
    };
  };
}
