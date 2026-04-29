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

ttr-server = {
isNormalUser = true;
group = "ttr-server";
extraGroups = [ "ttr-minimal" "plugdev" "wheel" "cups" "networkmanager" "scanner" "lp" "libvirtd" "libvirt" "docker" "ttr" "adbusers" "kvm" "plocate" ];
uid = 6000;  
};

ttr-minimal = {
isNormalUser = true;
group = "ttr-minimal";
extraGroups = [ "ttr-server" "plugdev" "wheel" "cups" "networkmanager" "scanner" "lp" "libvirtd" "libvirt" "docker" "ttr" "adbusers" "kvm" "plocate" ];
uid = 7000;  
};

muffin = {
isNormalUser = true;
group = "muffin";
extraGroups = [ "cups" ];
uid = 8000; 
};

family = {
isNormalUser = true;
group = "family";
extraGroups = [ "cups" ];
uid = 9000;  # It's good practice to explicitly set the UID
# };
};

users.groups = {

ttr = {
gid = 5000;
};

media = {
gid = 5001;
members = [ "ttr" "hotio" ];
};

ttr-server = {
gid = 6000;
};

ttr-minimal = {
gid = 7000;
};

muffin = {
gid = 8000;
};

family  = {
gid = 9000;
};

adbusers = {
};
};
}