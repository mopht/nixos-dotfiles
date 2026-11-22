# Intel Arc A750（DG2，PCI id 0x56a1）：xe 驱动 + VA-API 硬解。
# extraPackages32 供 32 位程序使用（Steam 客户端、32 位播放器）。
{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  # 让 xe 接管这块卡，i915 不 probe 它
  boot.kernelParams = [
    "i915.force_probe=!56a1"
    "xe.force_probe=56a1"
  ];
}
