{
  users = ./users;
  packages = ./packages;
  
  # Desktop environment
  de = ./desktop-environment;
  wayland = ./desktop-environment/wayland;
  x11 = ./desktop-environment/x11;

  # System
  system = ./system;

  # Sub system
  cups = ./system/cups;
  flake = ./system/flake;
  fontsDir = ./system/fonts;
  keyboard = ./system/keyboard;
  kernels = ./system/kernels;
  networkShare = ./system/network-share;
  power = ./system/power;
  servicesDir = ./system/services;
}
