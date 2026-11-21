{ pkgs, ... }:

{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.btop.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

  home.file.".config/clangd/config.yaml".text = ''
    # Global settings for all files
    CompileFlags:
      Add: [-Wall, -Wextra]

    ---
    # Settings strictly for C++ files
    If:
      PathMatch: [.*\.cpp, .*\.hpp, .*\.cc]
    CompileFlags:
      Add: [-std=c++26, -stdlib=libc++, -xc++]

    ---
    # Settings strictly for C files
    If:
      PathMatch: .*\.c
    CompileFlags:
      Add: [-std=c17, -xc]
  '';
}
