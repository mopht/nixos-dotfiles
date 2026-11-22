{ inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    inputs.zen-browser.homeModules.beta
    ./pkgs.nix
    ./desktop/caelestia.nix
    ./desktop/fcitx5.nix
    ./desktop/theme.nix
    ./shell
    ./apps/editor.nix
    ./apps/media.nix
    ./apps/browser.nix
    ./apps/file-manager.nix
    ./misc.nix
  ];

  home.username = "mopht";
  home.homeDirectory = "/home/mopht";
  home.stateVersion = "26.05";

  manual.manpages.enable = false;
}
