# users.nix
{ config, pkgs, lib, ... }:

{
users.users = {

ttr-server = {
isNormalUser = true;
group = "ttr-server";
extraGroups = [ "plugdev" "wheel" "cups" "networkmanager" "scanner" "lp" "libvirtd" "libvirt" "docker" "ttr" "adbusers" "kvm" "plocate" ];
uid = 6000;  
};
};

users.groups = {

media = {
gid = 5001;
members = [ "ttr" "hotio" ];
};

ttr-server = {
gid = 6000;
};

adbusers = {
};
};
}