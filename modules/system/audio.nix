{ lib, pkgs, hostName, ... }:

lib.mkIf (builtins.elem hostName [ "desktop" "laptop" ]) {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
    pulseaudio
  ];
}
