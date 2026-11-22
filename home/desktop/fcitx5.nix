{ ... }:

{
  xdg.configFile."fcitx5/profile" = {
    source = ./fcitx5/profile;
    force = true;
  };

  xdg.dataFile."fcitx5/rime/default.custom.yaml" = {
    source = ./fcitx5/default.custom.yaml;
    force = true;
  };
}
