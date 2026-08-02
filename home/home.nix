{ inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    inputs.zen-browser.homeModules.beta
    ./pkgs.nix
    ./caelestia.nix
    ./display.nix
    ./fish.nix
    ./misc.nix
    ./file_manager.nix
  ];

  home.username = "mopht";
  home.homeDirectory = "/home/mopht";
  home.stateVersion = "26.05";
}
