{ hostName, ... }:

let
  hostSettings = {
    desktop = {
      allowedTCPPorts = [ 21 445 ];
      allowedUDPPorts = [ 21 445 ];
    };
    laptop = {
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    server = {
      allowedTCPPorts = [ 8096 21 445 ];
      allowedUDPPorts = [ 1900 7359 21 445 ];
    };
  };
  cfg = hostSettings.${hostName} or (throw "Unsupported hostName for firewall.nix: ${hostName}");
in
{
  networking.firewall = {
    enable = true;
    inherit (cfg) allowedTCPPorts allowedUDPPorts;
  };
}

# jellyifin: 8096/TCP, 1900/UDP, and 7359/UDP