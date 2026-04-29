{ config, lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd scroll";
        user = "greeter";
      };
    };
  };
}

# Change --cmd from scroll to whatever wayland de or wm that you want to use