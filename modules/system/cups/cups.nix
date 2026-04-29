{ config, lib, pkgs, ... }:

{

# Enable CUPS to print documents.
  # Discovery
  services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};
# Enable printing
  services.printing = {
  enable = true;
  listenAddresses = [ "*:631" ];
  allowFrom = [ "all" ];
  browsing = true;
  defaultShared = true;
};
}