{ pkgs, ... }:

{
  systemd.services.cloudflared = {
    description = "Cloudflare Tunnel";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      EnvironmentFile = "/etc/cloudflared/token";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN";
      Restart = "on-failure";
      RestartSec = "5s";
      DynamicUser = true;
    };
  };
}
