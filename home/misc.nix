{ config, pkgs, inputs, ... }:

{
  services.mpdris2-rs.enable = true;

  programs.superfile = {
    enable = true;

    settings = {
      skin = "default";
      show_hidden = true;
      show_icons = true;
    };
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
