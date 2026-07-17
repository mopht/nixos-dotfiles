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
    trustedInterfaces = [ "mihomo" ];
    checkReversePath = "loose";
    extraReversePathFilterRules = ''
      iifname { "mihomo" } accept comment "allow mihomo tun"
    '';
    allowedTCPPorts = [
      7890 # Clash HTTP proxy port
      7891 # Clash Socks port
      9097 # Clash Web API / Verge Controller
    ];
  };
}
