{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    clash-verge-rev
    lazygit
    btop
    fastfetch

    loupe
    swayimg

    nautilus
    superfile
    yazi

    spotify
    umu-launcher
    localsend

    vim neovim
    neovide
    tree-sitter

    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.cabal2nix
    haskellPackages.haskell-language-server

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
    llvmPackages.clang-tools
    llvmPackages.libcxx

    blueman
    ddcutil
    brightnessctl
    networkmanager
    libqalculate
    swappy
    libcava

    mpdris2-rs
    rmpc
    ffmpeg
    mutagen

    (python3.withPackages (ps: with ps; [ pillow
      pyzmq rawpy
      pillow-heif
      pillow vips
      # pillow-webp
    ]))
  ];
}
