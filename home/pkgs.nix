{ pkgs, inputs, ... }:

{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    hmcl
    go-musicfox
    onlyoffice-desktopeditors
    clash-verge-rev
    fastfetch

    typora
    glow
    iloader
    bibata-cursors
    loupe
    upscayl
    nautilus

    umu-launcher
    localsend

    # helix
    neovim
    neovide
    tree-sitter

    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.cabal2nix
    haskellPackages.haskell-language-server
    tree-sitter-grammars.tree-sitter-koka
    rust-analyzer
    mitscheme
    akkuPackages.scheme-langserver
    guile-lsp-server
    guile
    nixd
    koka
    swi-prolog
    idris2
    idris2Packages.idris2Lsp
    typescript-language-server
    purescript
    spago-legacy
    lua-language-server
    # moonbit-bin.latest

    bun
    esbuild
    nodejs

    cascadia-code
    source-han-sans
    noto-fonts
    noto-fonts-cjk-sans
    dejavu_fonts

    maple-mono.NF-CN
    maple-mono.NF

    carapace
    # hyperfine
    ripgrep
    xz
    unzip
    gh
    bat
    cargo
    rustc
    llvmPackages.clang-tools
    llvmPackages.libcxx
    llvmPackages.libcxxStdenv
    llvmPackages.libcxxClang

    exfatprogs
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
      python-pptx
      pyzmq
      rawpy
      pillow-heif
      pillow
      vips
    ]))
  ];

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
    "com.qq.QQ"
    "com.tencent.WeChat"
    "com.spotify.Client"
  ];

  services.flatpak.overrides.settings = {
    global = {
      Environment = {
        GTK_THEME = "Adwaita:dark";
      };
    };
  };
  # xdg.desktopEntries.qq = {
  #   name = "QQ";
  #   exec = "firejail qq %u";
  #   terminal = false;
  #   categories = [ "Network" "WebBrowser" ];
  # };
}
