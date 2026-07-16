{ config, pkgs, inputs, ... }:

{
  services.mpdris2-rs.enable = true;

  programs.superfile.enable = true;
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
