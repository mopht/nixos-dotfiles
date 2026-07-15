{ config, lib, pkgs, inputs, ... }:

{
  programs.hyprland.enable = true;
  services.greetd = {
    enable = true;

    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "mopht";
      };

      default_session = {
        command = "start-hyprland";
        user = "mopht";
      };
    };
  };
}
