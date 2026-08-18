{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    hmcl
    wechat
    go-musicfox
    onlyoffice-desktopeditors
    clash-verge-rev
    fastfetch

    iloader
    loupe
    upscayl
    nautilus

    spotify
    umu-launcher
    localsend

    neovim
    neovide
    tree-sitter

    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.cabal2nix
    haskellPackages.haskell-language-server
    tree-sitter-grammars.tree-sitter-koka
    koka
    swi-prolog
    idris2
    idris2Packages.idris2Lsp
    purescript
    spago-legacy

    bun

    source-han-sans
    noto-fonts
    noto-fonts-cjk-sans

    maple-mono.NF-CN
    maple-mono.NF

    carapace
    xz
    unzip
    gh
    cargo
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

    ffmpeg
    mutagen

    (python3.withPackages (ps: with ps; [
      pyzmq
      rawpy
      pillow-heif
      pillow
      vips
    ]))
  ];
}
