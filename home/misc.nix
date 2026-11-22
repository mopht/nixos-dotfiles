{ ... }:

{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.btop.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

  # Polkit 认证代理：Hyprland 官方实现，给需要提权的 GUI 操作弹窗
  # （fwupd、NetworkManager 编辑、分区工具等；udisks 挂载不走这里）
  services.hyprpolkitagent.enable = true;

  # 剪贴板历史：常驻监听 wl-paste，存入 cliphist（caelestia 的 clipboard 命令读取）
  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  home.file.".config/clangd/config.yaml".text = ''
    # Global settings for all files
    CompileFlags:
      Add: [-Wall, -Wextra]

    ---
    # Settings strictly for C++ files
    If:
      PathMatch: [.*\.cpp, .*\.hpp, .*\.cc]
    CompileFlags:
      Add: [-std=c++26, -stdlib=libc++, -xc++]

    ---
    # Settings strictly for C files
    If:
      PathMatch: .*\.c
    CompileFlags:
      Add: [-std=c17, -xc]
  '';
}
