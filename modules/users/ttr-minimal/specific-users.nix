# users.nix
{ config, pkgs, lib, ... }:

{
users.users = {

ttr-minimal = {
isNormalUser = true;
group = "ttr-minimal";
extraGroups = [ "plugdev" "wheel" "cups" "networkmanager" "scanner" "lp" "libvirtd" "libvirt" "docker" "ttr" "adbusers" "kvm" "plocate" ];
uid = 7000;  
};
};

users.groups = {

ttr-minimal = {
gid = 7000;
};

};
}