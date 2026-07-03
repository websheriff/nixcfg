{ config, ... }: {
  sops = {
    templates = {
      "qbittorrent/qbittorrent-conf.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: qbittorrent-conf
            namespace: media
          type: Opaque
          stringData:
            qbittorrent.conf: |
              [AutoRun]
              enabled=false
              program=
              
              [BitTorrent]
              Session\AddTorrentStopped=false
              Session\DefaultSavePath=/media/Downloads/
              Session\Port=6881
              Session\QueueingSystemEnabled=true
              Session\SSL\Port=41258
              Session\ShareLimitAction=Stop
              Session\TempPath=/media/Downloads/incomplete/
              Session\DHTEnabled=true
              Session\LSDEnabled=true
              Session\PeXEnabled=true
              
              [LegalNotice]
              Accepted=true
              
              [Meta]
              MigrationVersion=8
              
              [Network]
              PortForwardingEnabled=false
              Proxy\HostnameLookupEnabled=false
              Proxy\Profiles\BitTorrent=true
              Proxy\Profiles\Misc=true
              Proxy\Profiles\RSS=true
              
              [Preferences]
              Connection\PortRangeMin=6881
              Connection\UPnP=false
              Downloads\SavePath=/media/Downloads/
              Advanced\AnonymousMode=true
              Downloads\TempPath=/media/Downloads/incomplete/
              WebUI\Address=*
              WebUI\ServerDomains=*
              WebUI\HostHeaderValidation=false
              WebUI\CSRFProtection=false
              WebUI\Username=admin
              WebUI\Password_PBKDF2="${config.sops.placeholder."qbittorrent/password"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/qbittorrent-conf.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "gluetun/gluetun-vpn-secret.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: qbittorrent-vpn-secret
            namespace: media
          type: Opaque
          stringData:
            VPN_SERVICE_PROVIDER: mullvad
            VPN_TYPE: wireguard
            WIREGUARD_PRIVATE_KEY: ${config.sops.placeholder."mullvad/wireguard-private-key"}
            WIREGUARD_ADDRESSES: ${config.sops.placeholder."mullvad/wireguard-address"}
            SERVER_COUNTRIES: USA,Canada
        '';

        path = "/var/lib/rancher/k3s/server/manifests/qbittorrent-vpn-creds.yaml";
        owner = "root";
        group = "root";
        mode = "0600";
      };
    };
  };
}
