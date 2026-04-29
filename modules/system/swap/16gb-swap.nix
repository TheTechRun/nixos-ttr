{ config, lib, pkgs, ... }:

{

swapDevices = [ {
      device = "/var/lib/swapfile";
      size = 16*1024;
    } ];

}