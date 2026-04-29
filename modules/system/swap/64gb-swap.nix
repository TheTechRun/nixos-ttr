{ config, lib, pkgs, ... }:

{

swapDevices = [ {
      device = "/var/lib/swapfile";
      size = 64*1024;
    } ];

}