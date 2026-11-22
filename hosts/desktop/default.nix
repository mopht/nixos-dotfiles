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
  # 限制 ESP 中保留的启动项数量，避免几百 MB 的 /boot 被历史 generation 占满
  boot.loader.systemd-boot.configurationLimit = 10;
  # 启动菜单仍可选代，但不允许编辑内核参数（自动登录下防 init=/bin/sh 绕过）
  boot.loader.systemd-boot.editor = false;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [ "i2c-dev" ];

  # zram 场景下更积极地把冷页换进 zram
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
