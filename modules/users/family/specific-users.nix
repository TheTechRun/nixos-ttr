# users.nix
{ config, pkgs, lib, ... }:

{
users.users = {

family = {
isNormalUser = true;
group = "family";
extraGroups = [ "cups" ];
uid = 9000; 
};
};

users.groups = {

family  = {
gid = 9000;
};

adbusers = {
};
};
}