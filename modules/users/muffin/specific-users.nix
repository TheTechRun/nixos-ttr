# users.nix
{ config, pkgs, lib, ... }:

{
users.users = {

muffin = {
isNormalUser = true;
group = "muffin";
extraGroups = [ "cups" ];
uid = 8000; 
};
};

users.groups = {
muffin = {
gid = 8000;
};
};
}
