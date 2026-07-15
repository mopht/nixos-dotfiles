{ config, lib, pkgs, inputs, ... }:

{
  programs.gamescope.enable = true;
  programs.gamescope.capSysNice = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
