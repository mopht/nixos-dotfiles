{ pkgs, ... }:

{
  programs.zen-browser = {
    enable = true;

    nativeMessagingHosts = [
      pkgs.ff2mpv-rust
    ];

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableAppUpdate = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
    };

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        "browser.tabs.allow_transparent_browser" = true;

        "widget.wayland.fractional-scale.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "gfx.webrender.all" = true;

        "browser.aboutConfig.showWarning" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;

        "browser.tabs.warnOnClose" = false;
        "general.autoScroll" = true;
        "layout.css.devPixelsPerPx" = "-1.0";

        "zen.view.compact.hide-tabbar" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.workspaces.continue-where-left-off" = true;
      };

      containersForce = true;
      containers = {
        Personal = {
          id = 1;
          color = "blue";
          icon = "fingerprint";
        };
        Dev = {
          id = 2;
          color = "green";
          icon = "briefcase";
        };
        Media = {
          id = 3;
          color = "pink";
          icon = "chill";
        };
      };

      search = {
        force = true;
        default = "Google";
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nix" ];
          };

          "NixOS Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = [ "@opt" ];
          };

          "GitHub" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "code";
                  }
                ];
              }
            ];
            definedAliases = [ "@gh" ];
          };

          "Bilibili" = {
            urls = [ { template = "https://search.bilibili.com/all?keyword={searchTerms}"; } ];
            definedAliases = [ "@b" ];
          };

          # 隐藏不需要的默认内置引擎
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };
    };
  };
}
