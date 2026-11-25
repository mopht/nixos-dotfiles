{ pkgs, inputs, ... }:

{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    qt6Packages.fcitx5-configtool
    qtengine
    darkly
    qbittorrent
    anime4k
    prismlauncher
    telegram-desktop
    go-musicfox
    onlyoffice-desktopeditors
    fastfetch
    yt-dlp
    gobject-introspection

    antigravity-cli
    typora
    loupe
    swayimg
    upscayl
    nautilus
    ffmpegthumbnailer
    file-roller
    sioyek
    mission-center

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
    idris2
    idris2Packages.idris2Lsp
    typescript-language-server
    spago-legacy
    lua-language-server
    moonbit-bin.latest

    bun
    esbuild
    nodejs

    cascadia-code
    source-han-sans
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans

    maple-mono.NF-CN
    maple-mono.NF

    trash-cli
    pavucontrol
    hyprpicker
    ydotool
    wl-clipboard
    ripgrep
    xz
    fd
    unzip
    unar
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
    libqalculate
    swappy
    libcava

    ffmpeg
    mutagen

    (python3.withPackages (
      ps: with ps; [
        python-pptx
        pyzmq
        rawpy
        pillow-heif
        pillow
        vips
      ]
    ))
  ];

  services.flatpak.uninstallUnmanaged = true;
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
        XCURSOR_THEME = "Bibata-Modern-Classic";
        XCURSOR_SIZE = "24";
      };
    };
  };
}
