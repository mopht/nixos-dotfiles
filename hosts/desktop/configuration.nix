{ config, lib, pkgs, modulesPath, ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [ "i2c-dev" "i2c-core" ];

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };
}
