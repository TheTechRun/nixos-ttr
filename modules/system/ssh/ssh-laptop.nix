{ config, lib, pkgs, ... }:

{
# Server-side SSH configuration
services.openssh = {
enable = true;

settings = {
PasswordAuthentication = false;
PermitRootLogin = "no";
# Enable SFTP subsystem
Subsystem = "sftp internal-sftp";
};

# Listen on all IPv4 interfaces - we'll use firewall to control access
listenAddresses = [
{ addr = "0.0.0.0"; port = 22; }
];
};

# Enable FUSE
boot.kernelModules = [ "fuse" ];

# Install SSHFS and other useful SSH-related tools
environment.systemPackages = with pkgs; [
sshfs
openssh
fuse
];

# Set up SSH keys for your user
users.users.ttr = {
openssh.authorizedKeys.keys = [
# Desktop
"ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX you@example.com"

# Termux - Pixel 9 (Android):
"ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX you@example.com"

# Termux - Moto Stylus (Android):
"ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX you@example.com"

];
};

# SSH client configuration for remote PC
environment.etc."ssh/ssh_config".text = ''
Host remote
HostName remote
User ttr
Port 22
ForwardX11 yes
IdentityFile ~/.ssh/id_ed25519
ServerAliveInterval 60
ServerAliveCountMax 3
Compression yes
'';

# Enable X11 forwarding
services.xserver.enable = true;

# Allow users in the "fuse" group to use FUSE
users.groups.fuse = {};
users.users.ttr.extraGroups = [ "fuse" ];

# Add firewall rules to only allow SSH from Tailscale IPs
networking.firewall = {
enable = true;
allowedTCPPorts = [ 22 ];
extraCommands = ''
# Allow SSH only from Tailscale IPs
iptables -A INPUT -p tcp --dport 22 -s 100.64.0.0/10 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
'';
};
}