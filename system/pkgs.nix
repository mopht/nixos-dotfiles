{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
  ];

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    papirus-icon-theme
    material-symbols
    glaze
    aubio
    pipewire
    git
    wget
    gcc
    gdb
    cmake
  ];
}
