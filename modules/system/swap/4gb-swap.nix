{ config, lib, pkgs, ... }:

{

swapDevices = [ {
      device = "/var/lib/swapfile";
      size = 4*1024;
    } ];

}