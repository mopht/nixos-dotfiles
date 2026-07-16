{ config, pkgs, inputs, ... }:

{
  services.mpdris2-rs.enable = true;

  programs.superfile = {
    enable = true;

    settings = {
      skin = "default";
      show_hidden = true;
      show_icons = true;
      theme = "catppuccin-frappe";
      default_sort_type = 0;
      transparent_background = true;
    };
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
