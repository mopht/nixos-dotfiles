{ pkgs, inputs, ... }:

{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Qt 平台主题：caelestia 把配色写进 ~/.config/qtengine，
    # hypr 侧设置 QT_QPA_PLATFORMTHEME=qtengine；样式用它模板里的 Darkly
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

    antigravity-cli
    typora
    loupe
    swayimg
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
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    # dejavu_fonts

    maple-mono.NF-CN
    maple-mono.NF

    trash-cli
    pavucontrol
    hyprpicker
    ydotool
    wl-clipboard
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

  home.sessionVariables.NIX_LDFLAGS = "-L${pkgs.llvmPackages.libcxx}/lib";

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
