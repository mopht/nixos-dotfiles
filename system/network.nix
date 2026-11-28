{ ... }:

{
  services.usbmuxd.enable = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.settings.keyfile.path = "/var/lib/NetworkManager/system-connections";

  programs.clash-verge.serviceMode = true;
  programs.clash-verge.tunMode = true;
  programs.clash-verge.enable = true;

  services.resolved.enable = true;
  networking.wireless.iwd.settings = {
    General = {
      EnableNetworkConfiguration = true;
    };
    Network = {
      NameResolvingService = "systemd";
    };
  };

  services.printing = {
    enable = true;
    drivers = [ ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # avahi-daemon.service 带 ConfigurationDirectory=avahi/services，只读 /etc 下
  # systemd 无法创建该目录（status 241/CONFIGURATION_DIRECTORY）。声明一个占位文件
  # 让 /etc/avahi/services 先存在，与 /etc/iwd、/etc/bluetooth 同理。
  environment.etc."avahi/services/.keep".text = "";

  networking.firewall = rec {
    enable = true;

    allowedTCPPorts = [
      53317
      25565
    ];
    allowedUDPPorts = allowedTCPPorts;

    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
