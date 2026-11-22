{ pkgs, ... }:

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
}
