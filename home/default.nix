{ inputs, username, ... }:

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

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.11";

  manual.manpages.enable = false;
}
