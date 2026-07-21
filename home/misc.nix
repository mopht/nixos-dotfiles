{ config, pkgs, inputs, ... }:

{
  services.mpdris2-rs.enable = true;

  programs.lazygit.enable = true;
  programs.clangd = {
    enable = true;
    arguments = [
      "-std=c++26"
      "-stdlib=libc++"
    ];
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };
}
