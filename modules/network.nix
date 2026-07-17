{ config, lib, pkgs, inputs, ... }:

{
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.clash-verge.serviceMode = true;
  programs.clash-verge.tunMode = true;
  programs.clash-verge.enable = true;

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };
}
