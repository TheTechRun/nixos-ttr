{ hostName, lib, pkgs, ... }:

let
  hostSettings = {
    desktop = {
      dockerWaitForNetwork = true;
      dockerLiveRestore = true;
    };
    laptop = {
      dockerWaitForNetwork = false;
      dockerLiveRestore = false;
    };
    server = {
      dockerWaitForNetwork = true;
      dockerLiveRestore = true;
    };
  };
  cfg = hostSettings.${hostName} or (throw "Unsupported hostName for virtualization.nix: ${hostName}");
in
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
    docker = lib.mkMerge [
      {
        enable = true;
        enableOnBoot = true;
      }
      (lib.mkIf cfg.dockerLiveRestore {
        autoPrune.enable = true;
        daemon.settings = {
          live-restore = true;
        };
      })
    ];
    oci-containers.backend = "docker";
  };

  systemd.services.docker = lib.mkIf cfg.dockerWaitForNetwork {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    swtpm
    OVMF
  ];

  programs.dconf.enable = true;

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
      sleep 2

      ${pkgs.libvirt}/bin/virsh net-info default >/dev/null 2>&1
      if [ $? -ne 0 ]; then
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

      ${pkgs.libvirt}/bin/virsh net-list | grep -q default || \
        ${pkgs.libvirt}/bin/virsh net-start default

      ${pkgs.libvirt}/bin/virsh net-autostart default
    '';
  };
}
