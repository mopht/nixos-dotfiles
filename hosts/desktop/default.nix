{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./gpu.nix
    ./mounts.nix
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

  boot.kernel.sysctl = {
    "vm.page-cluster" = 0;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.editor = false;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  hardware.i2c.enable = true;

  boot.kernel.sysctl."vm.swappiness" = 180;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.fwupd.enable = true;
  services.smartd.enable = true;

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
}
