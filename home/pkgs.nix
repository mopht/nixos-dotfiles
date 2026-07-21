{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    hmcl
    wechat
    onlyoffice-desktopeditors
    clash-verge-rev
    btop
    fastfetch

    loupe
    swayimg

    nautilus

    spotify
    umu-launcher
    localsend

    neovim neovide
    tree-sitter

    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.cabal2nix
    haskellPackages.haskell-language-server

    maple-mono.NF-CN
    maple-mono.NF

    awww cava

    bash carapace
    xz unzip
    gh cargo
    llvmPackages.clang-tools
    llvmPackages.libcxx
    llvmPackages.libcxxClang

    blueman
    ddcutil
    brightnessctl
    networkmanager
    libqalculate
    swappy
    libcava

    rmpc
    ffmpeg
    mutagen

    (python3.withPackages (ps: with ps; [
      pyzmq rawpy
      pillow-heif
      pillow vips
    ]))
  ];
}
