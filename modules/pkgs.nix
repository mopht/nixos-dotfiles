{ pkgs, ... }:

{
  programs.nix-ld.enable = true;
  services.flatpak.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
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

  # programs.firejail = {
  #   enable = true;
  #   wrappedBinaries = {
  #     qq = {
  #       executable = "${pkgs.qq}/bin/qq";
  #       profile = "${pkgs.firejail}/etc/firejail/qq.profile";
  #       extraArgs = [
  #         "--noprofile"
  #         "--private"
  #         "--noroot"
  #         "--nonewprivs"
  #       ];
  #     };
  #
  #     wechat = {
  #       executable = "${pkgs.wechat}/bin/wechat";
  #       profile = "${pkgs.firejail}/etc/firejail/wechat.profile";
  #       extraArgs = [
  #         "--noprofile"
  #         "--private"
  #         "--noroot"
  #         "--nonewprivs"
  #       ];
  #     };
  #   };
  # };
}
