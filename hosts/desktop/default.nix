{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../system/core.nix
    ../../system/pkgs.nix
    ../../system/network.nix
    ../../system/desktop
    ../../system/hardware/audio.nix
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/gaming.nix
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
  };

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
    useXkbConfig = true;
  };
}
