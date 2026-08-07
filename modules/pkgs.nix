{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
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
