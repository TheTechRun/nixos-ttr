# users.nix
{ config, pkgs, lib, ... }:

{
users.users = {

ttr = {
isNormalUser = true;
group = "ttr";
extraGroups = [ "ttr-minimal" "ttr-server" "plugdev" "wheel" "cups" "networkmanager" "scanner" "lp" "libvirtd" "libvirt" "docker" "ttr" "adbusers" "kvm" "plocate" ];
uid = 5000;  # explicitly set the UID
};
};

users.groups = {

ttr = {
gid = 5000;
};

media = {
gid = 5001;
members = [ "ttr" "hotio" ];
};

adbusers = {
};
};
}

