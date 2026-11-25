# NixOS 桌面配置

本仓库为一台单机 NixOS 桌面的完整配置。系统级部分由 NixOS 模块声明，用户环境由 Home Manager 声明，两者通过 Nix Flakes 统一组织。Hyprland 的键位与窗口规则不在本仓库，见下文说明。

## 系统概览

| 项目 | 配置 |
|------|------|
| 操作系统 | NixOS unstable（26.11） |
| 包管理器 | Lix（Nix 分支） |
| 桌面环境 | Hyprland（Wayland） |
| Shell | Nushell；Fish 提供外部补全；Starship 负责提示符 |
| 终端 | Kitty |
| 编辑器 | Neovim / Neovide / Helix |
| 浏览器 | Zen Browser |
| 输入法 | Fcitx5 + Rime（雾凇拼音），profile 由 Home Manager 管理 |
| 文件管理 | Nautilus / Superfile（TUI） |
| 媒体播放 | mpv（Anime4K）/ MPD + rmpc |
| 登录 | greetd + UWSM |
| 代理 | Clash Verge Rev |
| 密钥 | sops-nix（Age），当前仅保存用户密码 hash |
| 主题 | Caelestia Shell / Papirus-Dark / Bibata 光标 |

## 硬件与系统维护

CPU 为 Intel 平台，支持 VT-x/KVM，当前未配置 libvirt 或 QEMU。GPU 为 Intel Arc A750（设备 ID `56a1`），使用 `xe` 驱动，启用 VA-API 硬件解码与 32 位支持。内核使用 `linuxPackages_zen`。

引导使用 systemd-boot（UEFI），超时 3 秒，保留最近 10 个启动项，并禁用内核参数编辑。交换仅使用 zram（内存的 25%，zstd 压缩），`vm.swappiness` 设为 180，未配置 swap 分区或 swapfile。根文件系统为 Btrfs，挂载选项包含 `compress=zstd`、`noatime` 与 `discard=async`。

快照由 Snapper 以 timeline 模式管理，`/home` 保留 5 小时、7 天、2 周、2 个月，`~/Music` 子卷保留 2 小时、7 天、2 周、2 个月。`~/.cache` 为独立子卷，不参与 `/home` 快照，以避免缓存的高频变化放大快照占用。Btrfs autoScrub 每月执行一次，覆盖 `/`（含 `@home`）、`~/Game` 与 `~/Music`。

系统保护与例行维护如下：

- `systemd-oomd`：在内存压力升高时终止占用较高的进程，避免重型编译使系统失去响应。
- `nix.optimise`：每周日 20:00 对 Nix store 去重；未启用 `auto-optimise-store`。
- `fwupd` 与 `smartd`：固件更新与磁盘健康监测。
- `udisks2` 与 `gvfs`：外部存储自动挂载。
- `hyprpolkitagent` 与 GNOME Keyring：桌面授权代理与凭据环，greetd 登录时由 PAM 解锁。
- 剪贴板：`cliphist` 保存文本与图片历史，`wl-clip-persist` 维持剪贴板内容，`wl-clipboard` 提供 `wl-copy`/`wl-paste`。
- 清理策略：系统代由 `nix.gc` 每周删除 14 天前的项，用户代由 `nh clean` 保留 4 天或最近 3 个。
- 日志：journald 持久化，`SystemMaxUse` 为 1G，可通过 `journalctl -b -1` 查看上次启动的日志。
- Nix 设置：`trusted-users` 增加 `mopht`，`substituters` 在 `cache.nixos.org` 之外加入 nix-community 缓存。

### 分区布局

| 挂载点 | 类型 | 说明 |
|--------|------|------|
| `/` | Btrfs 子卷 `@` | 系统根目录 |
| `/home` | Btrfs 子卷 `@home` | 用户目录，参与 Snapper 快照 |
| `/boot` | VFAT | EFI 启动分区 |
| `~/Game` | Btrfs 顶层 | 游戏存储 |
| `~/Music` | Btrfs 子卷 `music` | 音乐存储，参与 Snapper 快照 |
| `~/.cache` | Btrfs 子卷 `@cache` | 缓存，不参与 `/home` 快照 |

## 项目结构

```
.
├── flake.nix                              # Flake 入口，定义 inputs 与 outputs
├── flake.lock
├── .gitignore                             # 忽略 result / *.hm-bak / .direnv
├── .sops.yaml                             # sops 加密规则与公钥
├── secrets/
│   └── secrets.yaml                       # Age 加密的密文
│
├── hosts/
│   └── desktop/
│       ├── default.nix                    # 主机入口（内核、启动、zram、i2c）
│       ├── gpu.nix                        # Intel Arc A750（xe 驱动、VA-API、32 位解码）
│       ├── hardware.nix                   # nixos-generate-config 生成的分区与微码
│       ├── mounts.nix                     # 手工维护的 ~/Game、~/Music、~/.cache 挂载点
│       └── storage.nix                    # Snapper 与 btrfs autoScrub
│
├── system/                                # 系统级模块
│   ├── core.nix                           # 时区、Lix、Nix 设置、用户
│   ├── pkgs.nix                           # 系统软件包、Flatpak、nix-ld
│   ├── sops.nix                           # sops-nix 密钥
│   ├── network.nix                        # 网络、防火墙、打印、代理
│   ├── desktop/
│   │   ├── default.nix                    # Hyprland、greetd、XDG Portal、Sunshine
│   │   └── fcitx5.nix                     # 输入法（Fcitx5 + Rime）
│   └── hardware/
│       ├── audio.nix                      # PipeWire 与 MPD
│       ├── bluetooth.nix                  # 蓝牙与 xpadneo
│       └── gaming.nix                     # Steam、Gamescope、Proton GE
│
└── home/                                  # Home Manager 用户配置
    ├── default.nix                        # 入口
    ├── pkgs.nix                           # 用户软件包、Flatpak、字体
    ├── misc.nix                           # KDE Connect、btop、nh、polkit、剪贴板
    ├── desktop/
    │   ├── caelestia.nix                  # Caelestia Shell 与 Gammastep
    │   ├── fcitx5.nix                     # 输入法 profile 与 rime 配置
    │   ├── fcitx5/                        # profile、default.custom.yaml
    │   └── theme.nix                      # GTK/Qt 主题、光标、暗色模式
    ├── shell/
    │   ├── default.nix                    # Nushell、Kitty、Zoxide、Eza、Starship
    │   └── starship.toml                  # Starship 配置，以只读链接引入
    └── apps/
        ├── browser.nix                    # Zen Browser 与 ff2mpv
        ├── editor.nix                     # Helix 与 Lazygit
        ├── file-manager.nix               # Superfile
        └── media.nix                      # mpv（Anime4K）、OBS、rmpc
```

Hyprland 的键位、窗口规则、变量与配色生成位于 [hyprland-dotfiles](https://github.com/mopht/hyprland-dotfiles)，需克隆到 `~/.config/hypr`。`~/.config/hypr/scheme/current.lua` 在 caelestia 更换配色时自动生成，不纳入任何仓库。

## Flake 输入

| Input | 说明 |
|-------|------|
| [nixpkgs](https://github.com/NixOS/nixpkgs)（unstable） | 软件包源 |
| [home-manager](https://github.com/nix-community/home-manager) | 声明式用户环境 |
| [nix-flatpak](https://github.com/gmodena/nix-flatpak) | 声明式 Flatpak 管理 |
| [moonbit-overlay](https://github.com/moonbit-community/moonbit-overlay) | MoonBit 工具链 overlay |
| [caelestia-shell](https://github.com/caelestia-dots/shell) | Hyprland 桌面 Shell |
| [zen-browser](https://github.com/0xc000022070/zen-browser-flake) | Zen Browser（Firefox 分支） |
| [sops-nix](https://github.com/Mic92/sops-nix) | Secrets 管理（Age / sops） |

除 `nix-flatpak` 外，其余输入均声明 `nixpkgs.follows = "nixpkgs"`，因此共用同一 nixpkgs 版本；`caelestia-shell` 的传递依赖沿用其自身 lock。

## 游戏

Steam 启用 Remote Play 与 Gamescope session，`extraCompatPackages` 加入 `proton-ge-bin`。Gamescope 允许 `capSysNice`；GameMode 提供 `gamemoderun`，并启用 Steam 手柄与 VR 设备的 udev 规则。`umu-launcher` 用于非 Steam 游戏，`PrismLauncher` 用于 Minecraft。

## 多媒体与视听

音频由 PipeWire 提供，同时启用 PulseAudio 与 ALSA 兼容层。MPD 以 PipeWire 作为输出，客户端为 `rmpc`（TUI）与 `go-musicfox`（网易云音乐 TUI）。

mpv 使用 Vulkan 与 Wayland 输出，VA-API 硬件解码；Anime4K 着色器分 L 与 VL 两档，各含 Balanced、Sharp、Denoise 三种组合，绑定 `Ctrl+1/2/3`（L 档）、`Ctrl+5/6/7`（VL 档）与 `Ctrl+0`（清除）。弹幕由 `uosc-danmaku` 提供，`yt-dlp` 复用 Zen Browser 的 cookies。

`swayimg` 为 Wayland 图片查看器，通过 Lua 配置：默认无边框、自适应缩放，支持画廊（`g`）与幻灯片（`s`）模式；`h`/`l` 切换图片，画廊内 `h`/`j`/`k`/`l` 选择，`Space` 下一张，`r`/`R` 旋转，`i` 显示元信息，`Delete` 经 `trash-cli` 移入回收站。

其余：`Loupe`（GNOME 图片查看器）、`EasyEffects`（麦克风降噪与耳机 EQ）、`OBS Studio`（VA-API 与 wlrobs 录屏）、`Nautilus`（配合 file-roller 与 ffmpegthumbnailer）、Spotify（Flatpak）。

## 浏览器（Zen Browser）

通过 `ff2mpv-rust` 将网页视频交给 mpv 播放。策略项禁用遥测、Pocket、体验研究与内置更新。图形相关设置启用 Wayland 分数缩放、VA-API 硬解与 WebRender。使用 container 标签隔离 Personal、Dev、Media 三类浏览环境。搜索关键字为 `@nix`（Nix Packages）、`@opt`（NixOS Options）、`@gh`（GitHub code search）与 `@b`（哔哩哔哩）。

## 开发环境

| 语言 | 工具 |
|------|------|
| Rust | rustc, cargo, rust-analyzer |
| Haskell | GHC, cabal-install, haskell-language-server, cabal2nix |
| C/C++ | GCC, clang-tools, libc++, CMake, GDB |
| JavaScript/TypeScript | Node.js, Bun, esbuild, typescript-language-server |
| Nix | nixd, nixfmt |
| MoonBit | moonbit-bin（via overlay） |
| Koka | koka, tree-sitter-koka |
| Idris 2 | idris2, idris2Lsp |
| Scheme | MIT/GNU Scheme, Guile, scheme-langserver, guile-lsp-server |
| Lua | lua-language-server |
| Python | python3（pillow, pillow-heif, rawpy, pyvips, pyzmq, python-pptx） |

工具方面，Neovim/Neovide 为默认编辑器（`$EDITOR`/`$VISUAL`）；Helix 使用 Everforest Dark 透明主题与相对行号；Lazygit 为 Git TUI；`gh` 为 GitHub CLI；`direnv` 与 `nix-direnv` 在进入目录时激活项目 Flake 环境并创建 GC root；`clangd` 配置为 C17 与 C++26（libc++）；Typora 用于 Markdown 编辑。

## 网络与连接

网络由 NetworkManager 管理，代理为 Clash Verge Rev，启用 TUN 与 Service 模式。蓝牙启用，图形客户端为 Blueman，并通过 xpadneo 支持 Xbox 手柄。KDE Connect 使用 1714–1764 端口，LocalSend 使用 53317 端口，两者已在防火墙放行。Sunshine 用于远程串流，按需启动，未设为开机自启。`usbmuxd` 用于 iOS 设备连接。打印使用 CUPS 与 Avahi（mDNS）。

## 外观与体验

Shell 为 Caelestia（基于 Quickshell）。GTK 主题为 adw-gtk3-dark，dconf 设置 `prefer-dark`；Qt 主题由 qtengine 与 Darkly 提供，配色由 caelestia 生成。图标为 Papirus-Dark，光标为 Bibata-Modern-Classic（24px）。

字体方面，等宽字体为 Maple Mono NF CN 与 Cascadia Code，终端行高在基础值上增加 7px；正文字体为 Source Han Sans 与 Noto Sans CJK；emoji 使用 Noto Color Emoji。`fontconfig.defaultFonts` 固定中文、等宽与 emoji 的回退顺序。

终端为 Kitty，背景不透明度 0.45，Nushell 作为默认 shell。夜间屏幕色温由 Gammastep 调节，使用手动坐标，日间 6500K、夜间 3500K 平滑过渡；默认程序通过 `xdg.mimeApps` 声明，覆盖浏览器、图片、视频、压缩包、磁力链接与目录。

桌面会话由 greetd 以 `mopht` 自动登录并启动 `uwsm start hyprland-uwsm.desktop`；`initial_session` 与 `default_session` 指向同一命令，因此注销后会立即重新登录。

## 使用方法

### 首次部署

```bash
git clone https://github.com/mopht/nixos-dotfiles.git /etc/nixos
cd /etc/nixos
sudo nixos-rebuild switch --flake .#nixos
```

```bash
sudo btrfs subvolume create /home/mopht/Music/.snapshots
```

### 日常更新

```bash
# 更新 flake inputs
nix flake update

# 大更新（内核或 nixpkgs）建议先 boot，重启验证后再 switch：
#   nh os boot     # 仅设为下次启动
#   nh os switch   # 构建并立即切换
#   nh os rollback
nh os switch

# 提交前求值与构建校验（系统与 Home Manager 均会构建）
nix flake check
```

新增的配置文件需先 `git add`，否则 flake 无法读取。

### 格式化

```bash
nix fmt
```

## 密钥管理

使用 [sops-nix](https://github.com/Mic92/sops-nix) 管理敏感数据，密文存放于 `secrets/secrets.yaml`（Age 加密）。

当前仅声明 `mopht-passwd` 一个 secret，用于 `users.users.mopht.hashedPasswordFile`。Age 私钥位于 `/var/lib/sops-nix/key.txt`（属主为 root），不属于任何仓库，换机或重装前需单独备份，否则将无法解密 `secrets/secrets.yaml`。

## 移植说明

本配置针对单台机器编写，直接在其他机器上执行 `nh os switch` 会失败或产生非预期结果。需要调整的内容如下。

1. 硬件：`hosts/desktop/hardware.nix` 中的分区 UUID 来自本机，应用 `nixos-generate-config --show-hardware-config` 重新生成后替换。GPU、挂载点与快照配置分别位于 `hosts/desktop/gpu.nix`、`hosts/desktop/mounts.nix` 与 `hosts/desktop/storage.nix`。`~/Music` 需为独立 btrfs 子卷（`subvol=music`），Snapper 才能对其创建快照。
2. 用户名：`mopht` 在配置中为硬编码，至少需修改 `flake.nix` 中的 `home-manager.users.mopht`、`home/default.nix` 中的 `home.username` 与 `home.homeDirectory`、`system/core.nix` 中的 `users.users.mopht`（含固定 UID）、`system/sops.nix` 中的 age key 路径、`system/hardware/audio.nix` 中的 MPD 路径，以及 `hosts/desktop/storage.nix` 中的 `ALLOW_USERS`。
3. 密钥：`secrets/secrets.yaml` 使用作者的 age 公钥加密，`nh os switch` 会在 `sops-install-secrets` 阶段失败。可选择删除 `system/sops.nix` 中的 `sops.secrets.mopht-passwd` 与 `hashedPasswordFile`，首次登录后自行设置密码；或将新的 age 公钥加入 `.sops.yaml`，再执行 `sops updatekeys secrets/secrets.yaml`（此后该密钥可解密全部 secret）。即便能够解密，首次创建用户时仍沿用作者的密码 hash，登录后以 `passwd` 修改即可；NixOS 默认 `mutableUsers = true`，重建不会覆盖已修改的密码。
4. Hyprland 配置不在本仓库，需执行 `git clone https://github.com/mopht/hyprland-dotfiles.git ~/.config/hypr`，否则桌面没有键位绑定；`~/.config/caelestia` 由 Home Manager 生成。
5. 个人项：`home/misc.nix` 中的 `xdg.mimeApps` 引用了若干第三方应用，缺少对应程序时关联会失效；`system/network.nix` 的防火墙端口与 `home/apps/*` 的软件列表按需增删。

修改完成后执行 `nh os switch`。

## Flatpak 应用

通过 `nix-flatpak` 声明式管理：

| 应用 | 用途 |
|------|------|
| Flatseal | Flatpak 权限管理 |
| QQ | 即时通讯 |
| WeChat | 即时通讯 |
| Spotify | 音乐流媒体 |

所有 Flatpak 应用通过全局 override 使用 `Adwaita:dark` GTK 主题。

## 许可

个人配置，仅供参考。
