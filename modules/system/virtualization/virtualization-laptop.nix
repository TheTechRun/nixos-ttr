{ config, pkgs, ... }:

{
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    docker = {
      enable = true;
      enableOnBoot = true;
    };
    # Comment remains for future reference
    # Uncomment if you want to use Podman instead of Docker
    # podman = {
    #   enable = true;
    #   autoPrune.enable = true;
    #   defaultNetwork.settings = {
    #     dns_enabled = true;
    #     ipv6_enabled = false;
    #   };
    # };
  };

  # Keep existing settings
  virtualisation.oci-containers.backend = "docker"; #defaults to docker
  virtualisation.podman.enable = false;
  programs.virt-manager.enable = true;

  # Add necessary system packages for virtualization
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice spice-gtk
    spice-protocol
    virtio-win
    win-spice
    swtpm
    OVMF
  ];

  # Enable dconf (required for virt-manager settings)
  programs.dconf.enable = true;

  # Configure default network for libvirt
  systemd.services.libvirtd-default-network = {
    enable = true;
    description = "Creates and starts libvirt default network";
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      # Wait for libvirtd to be ready
      sleep 2
      
      # Check if default network exists
      ${pkgs.libvirt}/bin/virsh net-info default >/dev/null 2>&1
      if [ $? -ne 0 ]; then
        # Create default network if it doesn't exist
        ${pkgs.libvirt}/bin/virsh net-define ${pkgs.writeText "default-network.xml" ''
          <network>
            <name>default</name>
            <forward mode='nat'/>
            <bridge name='virbr0' stp='on' delay='0'/>
            <ip address='192.168.122.1' netmask='255.255.255.0'>
              <dhcp>
                <range start='192.168.122.2' end='192.168.122.254'/>
              </dhcp>
            </ip>
          </network>
        ''}
      fi
      
      # Start the network if it's not active
      ${pkgs.libvirt}/bin/virsh net-list | grep -q default || \
        ${pkgs.libvirt}/bin/virsh net-start default
      
      # Enable autostart
      ${pkgs.libvirt}/bin/virsh net-autostart default
    '';
  };
}
