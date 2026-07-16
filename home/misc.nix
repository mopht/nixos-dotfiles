{ config, pkgs, inputs, ... }:

{
  services.mpdris2-rs.enable = true;

  programs.lazygit.enable = true;

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
