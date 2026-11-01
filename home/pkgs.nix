{ pkgs, inputs, ... }:

{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # dsh
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    hmcl
    telegram-desktop
    go-musicfox
    onlyoffice-desktopeditors
    clash-verge-rev
    fastfetch

    antigravity-cli
    typora
    # iloader
    bibata-cursors
    loupe
    upscayl
    nautilus

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
    rust-analyzer
    mitscheme
    akkuPackages.scheme-langserver
    guile-lsp-server
    guile
    nixd
    koka
    # swi-prolog
    idris2
    idris2Packages.idris2Lsp
    typescript-language-server
    # purescript
    spago-legacy
    lua-language-server
    moonbit-bin.latest

    bun
    esbuild
    nodejs

    cascadia-code
    source-han-sans
    noto-fonts
    noto-fonts-cjk-sans
    # dejavu_fonts

    maple-mono.NF-CN
    maple-mono.NF

    btrfs-assistant
    trash-cli
    pavucontrol
    hyprpicker
    ydotool
    cliphist
    carapace
    # hyperfine
    ripgrep
    xz
    fd
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

  home.sessionVariables.NIX_LDFLAGS =
    "-L${pkgs.llvmPackages.libcxx}/lib";

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
}
