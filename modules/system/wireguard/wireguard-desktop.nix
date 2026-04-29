{ config, lib, pkgs, ... }:

{
  # Enable WireGuard
  networking.wireguard.enable = true;
  
  # Install WireGuard tools for QR code import
  environment.systemPackages = with pkgs; [
    wireguard-tools
    qrencode        # For generating QR codes
    zbar            # For reading QR codes from images/camera
  ];

  # NetworkManager integration for WireGuard
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  # WireGuard is built into modern kernels, no extra module needed
  
  # Client configuration (to VPS) - imported via NetworkManager or wireguard-ui
  # Server configuration (for phone to connect to desktop)
  # Uncomment and configure after generating keys:
  # networking.wireguard.interfaces = {
  #   wg1 = {
  #     # Desktop as server - different interface name to avoid conflicts
  #     ips = [ "10.9.0.1/24" ];  # Different subnet from VPS
  #     listenPort = 51821;       # Different port from VPS
  #     
  #     # Generate with: wg genkey | tee /home/ttr/wireguard-keys/desktop-private | wg pubkey > /home/ttr/wireguard-keys/desktop-public
  #     privateKeyFile = "/home/ttr/wireguard-keys/desktop-private";
  #     
  #     peers = [
  #       {
  #         # Phone's public key (generate separately)
  #         publicKey = "PHONE_PUBLIC_KEY_HERE";
  #         allowedIPs = [ "10.9.0.2/32" ];  # Phone's IP in this network
  #       }
  #     ];
  #   };
  # };
}
