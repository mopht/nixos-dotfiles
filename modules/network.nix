{ config, lib, pkgs, inputs, ... }:

{
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings.General.Exprimental = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.xpadneo.enable = true;

  programs.clash-verge.serviceMode = true;
  programs.clash-verge.tunMode = true;
  programs.clash-verge.enable = true;

  services.printing = {
    enable = true;
    drivers = [ ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };
}
