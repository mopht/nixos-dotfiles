{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries =
    (with pkgs; [
      libxcb libdrm libgbm libglvnd vulkan-loader libxkbcommon wayland

      glib gtk3 gdk-pixbuf pango cairo harfbuzz freetype fontconfig
      dbus at-spi2-core at-spi2-atk libcap

      nspr nss cups            # Electron / Chromium 三件套
      alsa-lib libpulseaudio

      icu krb5 sqlite libffi expat ncurses libxcrypt-legacy
      SDL2
    ])
    ++ (with pkgs.xorg; [
      libX11 libXext libXrender libXi libXtst libXrandr libXcursor libXfixes
      libXcomposite libXdamage libXxf86vm libXScrnSaver libSM libICE libxshmfence
    ]);

  services.flatpak.enable = true;
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    material-symbols
    glaze
    aubio
    pipewire
    git
    wget
    gcc
    gdb
    cmake
  ];
}
