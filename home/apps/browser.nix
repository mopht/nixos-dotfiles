{ pkgs, ... }:

{
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    nativeMessagingHosts = [ pkgs.ff2mpv ];
    profiles.default = {
      isDefault = true;
    };
  };
}
