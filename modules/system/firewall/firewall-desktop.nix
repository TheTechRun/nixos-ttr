{ config, lib, pkgs, ... }:

{
  networking = {
    firewall = {
       enable = true; # change this to enable and disable
       allowedTCPPorts = [ 21 22 445 ];
       allowedUDPPorts = [ 21 22 445 ];
    };

   # extraHosts = ''
  #    192.168.1.222 rustdesk.yadayada.com
  #  '';
  };
}

### PORTS ###
# 5008 - aiostreams
# 44 - Baikal
# 631 9100 5353 - Cups (Printer)
# 53317 - Localsend
# 8002 - Pyload
# 5000 - Pyserve
# 445 - Samba
# 22 - Ssh
# 2234 - Soulseek
# 6060 - Odin