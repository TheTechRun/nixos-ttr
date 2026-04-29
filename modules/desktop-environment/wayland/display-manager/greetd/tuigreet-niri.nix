{ config, lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri";
        user = "greeter";
      };
    };
  };
}

# Change --cmd from niri to whatever wayland de or wm that you want to use