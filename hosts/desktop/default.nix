{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./gpu.nix
    ./storage.nix
    ../../system/core.nix
    ../../system/pkgs.nix
    ../../system/sops.nix
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
  boot.loader.timeout = 3;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.editor = false;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [ "i2c-dev" ];

  boot.kernel.sysctl."vm.swappiness" = 180;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.fwupd.enable = true;
  services.smartd.enable = true;

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
}
