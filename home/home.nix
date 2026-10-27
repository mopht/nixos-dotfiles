{ inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    inputs.zen-browser.homeModules.beta
    ./pkgs.nix
    ./desktop.nix
    ./display.nix
    ./shell.nix
    ./misc.nix
    ./file_manager.nix
    ./editor.nix
  ];

  home.username = "mopht";
  home.homeDirectory = "/home/mopht";
  home.stateVersion = "26.05";
}
