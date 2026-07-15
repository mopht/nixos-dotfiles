{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    clash-verge-rev
    lazygit
    fastfetch

    nautilus
    superfile
    yazi

    localsend

    vim neovim
    neovide
    tree-sitter

    maple-mono.NF-CN
    maple-mono.NF

    awww
    kitty
    direnv
    eza zoxide

    bash fish
    carapace
    xz unzip gh
    cargo

    blueman
    ddcutil
    brightnessctl
    networkmanager
    libqalculate
    swappy
    libcava

    mpdris2-rs
    rmpc
  ];
}
