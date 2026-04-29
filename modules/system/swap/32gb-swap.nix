{ config, lib, pkgs, ... }:

{

swapDevices = [ {
      device = "/var/lib/swapfile";
      size = 32*1024;
    } ];

}