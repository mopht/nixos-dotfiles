{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # opencode
    hmcl
    wechat
    qq
    go-musicfox
    onlyoffice-desktopeditors
    clash-verge-rev
    fastfetch

    iloader
    bibata-cursors
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
    nixd
    koka
    swi-prolog
    idris2
    idris2Packages.idris2Lsp
    purescript
    spago-legacy

    bun
    esbuild
    nodejs

    source-han-sans
    noto-fonts
    noto-fonts-cjk-sans
    dejavu_fonts

    maple-mono.NF-CN
    maple-mono.NF

    carapace
    xz
    unzip
    gh
    bat
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
