# 输入法组（keyboard-us + rime）和 rime 的 schema 补丁也随 Nix 配置走。
#
# 这两个文件在运行时是可变的：fcitx5 退出/改设置时会重写 profile，rime 会往
# ~/.local/share/fcitx5/rime 里写 build/、userdb/ 等。这里只接管这两个文件本身，
# 用 store 里的只读副本链接过去，目录其余内容保持可写：
#   - 改输入法顺序 / schema 列表 → 改本目录下的文件，然后 nh os switch
#   - 在 fcitx5 设置界面里改的输入法组不会持久（下次 switch 会被覆盖）
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
