# NixOS 桌面配置

NixOS 桌面配置，系统与用户环境分别由 NixOS 模块和 Home Manager 声明，用 Flakes 组织。
Hyprland 的键位、窗口规则不在此仓库，见「项目结构」。

## 概览

| 项目 | 配置 |
|------|------|
| 操作系统 | NixOS unstable（26.11） |
| 包管理器 | Lix（Nix 分支） |
| 桌面环境 | Hyprland（Wayland） |
| Shell | Nushell（默认）；Fish 备用；Carapace 补全；Starship 提示符 |
| 终端 | Kitty |
| 编辑器 | Neovim / Neovide / Helix |
| 浏览器 | Zen Browser |
| 输入法 | Fcitx5 + Rime（雾凇拼音） |
| 文件管理 | Nautilus / Superfile（TUI） |
| 媒体播放 | mpv（Anime4K）/ MPD + rmpc |
| 登录 | greetd + UWSM |
| 代理 | Clash Verge Rev |
| 密钥 | sops-nix（Age），密码 hash 与弹幕过滤表 |
| 主题 | Caelestia Shell / adw-gtk3-dark / Papirus-Dark / Bibata |

## 硬件与存储

- CPU：Intel，支持 VT-x/KVM（加载 `kvm-intel`）；未配置 libvirt/QEMU；开启 Intel 微码更新
- GPU：Intel Arc A750（`56a1`），`xe` 驱动，VA-API 硬解，含 32 位
- 内核：`linuxPackages_zen`
- 引导：systemd-boot，超时 1s，保留 10 个启动项，禁止编辑内核参数，带 memtest86
- 交换：仅 zram（内存 25%，zstd），`vm.swappiness = 180`、`vm.page-cluster = 0`
- 根文件系统：Btrfs，`compress=zstd`、`noatime`、`discard=async`
- `/tmp`：tmpfs，上限 8G

### 分区

| 挂载点 | 类型 | 说明 |
|--------|------|------|
| `/` | Btrfs 子卷 `@` | 系统根目录 |
| `/home` | Btrfs 子卷 `@home` | 用户目录，参与 Snapper 快照 |
| `/boot` | VFAT | EFI 分区 |
| `~/Game` | Btrfs（独立分区） | 游戏存储，`compress=zstd:1`、`nofail` |
| `~/Music` | Btrfs 子卷 `music`（独立分区） | 音乐，参与 Snapper 快照 |
| `~/.cache` | Btrfs 子卷 `@cache` | 缓存，不参与 `/home` 快照 |

`@`、`@home`、`@cache` 在同一块盘上；`~/Game` 与 `~/Music` 各挂在另外的分区。

### `~/.cache` 子卷

`~/.cache` 单独一个子卷，`/home` 的 hourly 快照才不会把缓存一起快照。
首次切换前要先建一次子卷（否则挂载失败，只能靠 `nofail` 兜底成普通目录）：

```bash
sudo btrfs subvolume create <@home 所在 fs 的挂载点>/@cache
```

`systemd.tmpfiles` 会把目录改成 `mopht:users 0700`，保证用户可写。

### 快照与校验

- Snapper：`home`（`/home`）保留 5h/7d/2w/2m，`music`（`~/Music`）保留 2h/7d/2w/2m；每小时打点，每天清理
- autoScrub：每月一次，覆盖 `/`（含 `@home`）、`~/Game`、`~/Music`

## 项目结构

```
.
├── flake.nix                              # 入口，定义 inputs、outputs、checks、formatter
├── flake.lock
├── .gitignore                             # result / result-* / *.hm-bak / .direnv
├── .sops.yaml                             # sops 加密规则与公钥
├── secrets/
│   └── secrets.yaml                       # Age 密文
│
├── hosts/
│   └── desktop/
│       ├── default.nix                    # 主机入口：导入、内核、启动、zram、/etc overlay、userborn
│       ├── gpu.nix                        # Intel Arc A750：xe、VA-API、32 位
│       ├── hardware.nix                   # nixos-generate-config 生成的分区
│       ├── mounts.nix                     # 手工维护的 ~/Game、~/Music、~/.cache
│       └── storage.nix                    # Snapper 与 btrfs autoScrub
│
├── system/
│   ├── core.nix                           # 时区、Lix、Nix 设置、tmpfs /tmp、用户与组
│   ├── pkgs.nix                           # 系统包、Flatpak、nix-ld、AppImage
│   ├── sops.nix                           # sops-nix
│   ├── network.nix                        # 网络、防火墙、打印、Avahi、代理
│   ├── desktop/
│   │   ├── default.nix                    # Hyprland、greetd、Portal、Sunshine、upower
│   │   └── fcitx5.nix                     # Fcitx5 + Rime
│   └── hardware/
│       ├── audio.nix                      # PipeWire、power-profiles-daemon
│       ├── bluetooth.nix                  # 蓝牙、xpadneo
│       └── gaming.nix                     # Steam、Gamescope、Proton GE
│
└── home/
    ├── default.nix                        # 入口
    ├── pkgs.nix                           # 用户包、Flatpak、字体
    ├── misc.nix                           # MPD、KDE Connect、btop、nh、polkit、剪贴板、mimeApps、clangd
    ├── desktop/
    │   ├── caelestia.nix                  # Caelestia Shell、Gammastep
    │   ├── fcitx5.nix                     # 输入法 profile 与 rime 配置
    │   ├── fcitx5/                        # profile、default.custom.yaml
    │   └── theme.nix                      # GTK/Qt 主题、光标、暗色、字体回退
    ├── shell/
    │   ├── default.nix                    # Nushell、Fish、Carapace、Kitty、Zoxide、Eza、Starship、direnv、git
    │   └── starship.toml
    └── apps/
        ├── browser.nix                    # Zen Browser、ff2mpv
        ├── editor.nix                     # Helix、Lazygit
        ├── file-manager.nix               # Superfile
        └── media.nix                      # mpv、OBS、rmpc、swayimg
```

Hyprland 配置在 [hyprland-dotfiles](https://github.com/mopht/hyprland-dotfiles)，需 clone 到 `~/.config/hypr`。
`~/.config/hypr/scheme/current.lua` 由 caelestia 换配色时生成，不入库。

## Flake 输入

| Input | 说明 |
|-------|------|
| [nixpkgs](https://github.com/NixOS/nixpkgs)（unstable） | 软件包源 |
| [home-manager](https://github.com/nix-community/home-manager) | 用户环境 |
| [nix-flatpak](https://github.com/gmodena/nix-flatpak) | 声明式 Flatpak |
| [nix-index-database](https://github.com/nix-community/nix-index-database) | nix-index 数据库，并提供 `comma`（`,` 命令） |
| [moonbit-overlay](https://github.com/moonbit-community/moonbit-overlay) | MoonBit 工具链 |
| [caelestia-shell](https://github.com/caelestia-dots/shell) | Hyprland 桌面 Shell |
| [zen-browser](https://github.com/0xc000022070/zen-browser-flake) | Zen Browser |
| [sops-nix](https://github.com/Mic92/sops-nix) | Secrets（Age/sops） |

除 `nix-flatpak` 外，其余输入都 `follows` 本仓库的 nixpkgs；`zen-browser` 另外 follows `home-manager`。

输出：`nixosConfigurations.nixos`（主机名 `nixos`），外加 `checks`（系统 toplevel 与 Home Manager activation）和 `formatter`（nixfmt-tree）。

## 系统维护

- `systemd-oomd`：内存压力高时终止进程
- `/etc` 用 overlay 并设为只读（`system.etc.overlay.mutable = false`），配合 `services.userborn` 在开机时按声明写用户/组
- `nix.optimise`：每周日 20:00 去重 store
- `fwupd`、`smartd`：固件更新、磁盘健康
- `udisks2`、`gvfs`：外置存储自动挂载
- `upower`、`power-profiles-daemon`：电源与性能档位
- polkit 代理 + GNOME Keyring：greetd 登录时由 PAM 解锁
- 剪贴板：cliphist（文本/图片）、wl-clip-persist、wl-clipboard
- 清理：`nix.gc` 每周删 14 天前的系统代；`nh clean` 保留 4 天/3 个用户代
- 日志：journald 持久化，上限 1G，`journalctl -b -1` 可查上次启动
- 文档：关掉 NixOS manual 与 nixpkgs 包文档，man 缓存保留；Home Manager 的 man 页关闭
- Nix：Lix，`trusted-users` 加 `mopht`，`substituters` 加 nix-community 缓存，daemon 用 batch 调度，关闭 dirty 警告
- 网络栈：BBR 拥塞控制 + `fq`
- `comma`：`,` 后接包名即可临时运行（来自 nix-index-database）
- AppImage 支持 + `nix-ld`：预置一段 GTK/Qt/X11/Vulkan 动态库，外部二进制能直接跑
- 系统包：`gcc`/`gdb`/`cmake`、`git`/`wget`、`pipewire`、`material-symbols`、`Papirus` 图标

## 桌面环境

- Hyprland + UWSM；greetd 开机以 `mopht` 自动登录（`initial_session`），注销后回到 agreety 登录提示
- `xdg.portal` 以 hyprland + gtk 为主，`NIXOS_OZONE_WL = 1` 让 Electron 走 Wayland
- Caelestia Shell（Quickshell），配色由 caelestia 生成；24 小时制、摄氏、天气地点 shanwei、壁纸目录 `~/Pictures/Wallpapers`
- 输入法：Fcitx5 + Rime 雾凇拼音（`rime-ice`），profile 与 `default.custom.yaml` 由 Home Manager 管理
- 主题：adw-gtk3-dark（dconf `prefer-dark`）、qtengine + Darkly、Papirus-Dark、Bibata-Modern-Classic 24px
- 字体：Maple Mono NF CN / Cascadia Code，Source Han Sans / Noto Sans CJK，Noto Color Emoji；`fontconfig.defaultFonts` 固定中文/等宽/emoji 回退顺序
- 终端：Kitty，背景 0.45，字号 17，行高 +7px，光标 beam + trail，默认 Nushell
- 夜间：Gammastep 手动坐标（22.79, 115.36），日 6500K / 夜 3500K
- 默认程序：`xdg.mimeApps`（浏览器 Zen、PDF Sioyek、图片 swayimg、音视频 mpv、压缩包 File Roller、磁力 qBittorrent、目录 Nautilus、Markdown Typora）

## 应用

### 浏览器

- Zen Browser：`ff2mpv-rust` 可以把网页视频交由 mpv 播放
- 策略：关遥测、体验研究、Pocket、内置更新、密码管理器
- 图形：Wayland 分数缩放、VA-API、WebRender
- 界面：透明标签栏，隐藏 tabbar/toolbar，workspaces 续用上次状态
- container：Personal / Dev / Media（强制启用）
- 搜索关键字：`@nix`、`@opt`、`@gh`、`@b`，默认 Google，隐藏 Bing/eBay

### 多媒体

- 音频：PipeWire，含 PulseAudio/ALSA 兼容
- MPD：PipeWire 输出，音乐在 `~/Music/file`，列表在 `~/Music/playlists`；客户端 rmpc、go-musicfox，`mpdris2-rs` 提供 MPRIS 控制
- mpv：Vulkan + Wayland（`gpu-next` + `waylandvk`）+ VA-API
  - Anime4K：L 档 `Ctrl+1/2/3`，VL 档 `Ctrl+5/6/7`，`Ctrl+0` 清除
  - 弹幕 uosc-danmaku，过滤表来自 sops（`/run/secrets/danmaku-filter`）；yt-dlp 复用 Zen 的 cookies
  - 插件：uosc、thumbfast、quality-menu、playlistmanager、mpris、evafast、memo、smartskip、reload
- OBS：VA-API 编码 + wlrobs、背景移除、PipeWire 音频采集
- swayimg：Lua 配置，画廊 `g`、幻灯片 `s`，`h`/`l` 切图，`Delete` 进回收站
- Loupe、EasyEffects、Nautilus（file-roller、ffmpegthumbnailer）
- Spotify：Flatpak

### 游戏

- Steam：Remote Play、Gamescope session
- Proton GE（`extraCompatPackages`）
- Gamescope `capSysNice`，GameMode
- Steam 手柄/VR 的 udev 规则，xpadneo 接 Xbox 手柄
- umu-launcher、PrismLauncher

### 开发

| 语言 | 工具 |
|------|------|
| Rust | rustc, cargo, rust-analyzer |
| Haskell | GHC, cabal-install, HLS, cabal2nix |
| C/C++ | GCC, clang-tools, libc++（含 stdenv/clang）, CMake, GDB |
| JS/TS | Node.js, Bun, esbuild, typescript-language-server |
| Nix | nixd（`nix fmt` 用 nixfmt-tree） |
| MoonBit | moonbit-bin（overlay） |
| Koka | koka, tree-sitter-koka |
| Idris 2 | idris2, idris2Lsp |
| Scheme | MIT/GNU Scheme, Guile, scheme-langserver, guile-lsp-server |
| Lua | lua-language-server |
| PureScript | spago-legacy |
| Python | python3（pillow, pillow-heif, rawpy, pyvips, pyzmq, python-pptx） |

- 默认编辑器：Neovim/Neovide（`$EDITOR`/`$VISUAL`）
- Helix：`mtheme`（继承 everforest_dark），相对行号，`j.k` 退出插入，`Ctrl+hjkl` 切窗口
- Lazygit、gh、Typora、sioyek、tree-sitter
- direnv + nix-direnv，进目录激活 Flake 环境并建 GC root
- clangd：C17 / C++26（libc++），配置写在 `~/.config/clangd/config.yaml`

### 其他工具

- 通信：Telegram，QQ / WeChat（Flatpak），KDE Connect，LocalSend
- 下载：qBittorrent（磁力/种子默认）
- 文档：OnlyOffice、Typora、Sioyek
- 图像：Loupe、swayimg、Upscayl、swappy
- 系统：Mission Center、btop、fastfetch、pavucontrol、ddcutil、brightnessctl、libqalculate、hyprpicker、ydotool
- 文件：trash-cli、unar/unzip、exfatprogs、fd、ripgrep、fzf、bat、jq

## 网络

- NetworkManager
- Clash Verge Rev：TUN + Service
- 蓝牙：Blueman、xpadneo
- KDE Connect：1714–1764
- LocalSend：53317
- Minecraft：25565
- Avahi：`openFirewall`（5353）；CUPS 打印；usbmuxd（iOS 设备）
- Sunshine：按需启动，未开机自启，端口由模块自行放行

## 使用

### 首次部署

```bash
git clone https://github.com/mopht/nixos-dotfiles.git ~/nixos-config
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```

`nh` 的 `flake` 指向 `~/nixos-config`（见 `home/misc.nix`），换目录要同步改。

### 日常更新

```bash
nix flake update

# 大更新（内核/nixpkgs）建议先 boot，重启验证后再 switch
nh os switch
# nh os boot / nh os rollback

# 提交前求值 + 构建校验
nix flake check
```

新增文件要 `git add`，否则 flake 看不到。

### 格式化

```bash
nix fmt
```

## 密钥管理

- 密文在 `secrets/secrets.yaml`，Age 加密，recipients 为 `mopht_age` 与 `mopht_ssh`
- `mopht-passwd`：`hashedPasswordFile`，`neededForUsers`
- `danmaku-filter`：mpv 弹幕过滤表，owner 为 `mopht`，`mode = 0400`，路径 `/run/secrets/danmaku-filter`
- 编辑：`sops secrets/secrets.yaml`（默认读 `~/.config/sops/age/keys.txt`）
- sops-nix 开机时用 `/var/lib/sops-nix/key.txt` 解密；两个 key 都是 recipient，换机前都要备份

## 移植说明

1. 硬件：`hardware.nix` 的 UUID 换成本机的（`nixos-generate-config --show-hardware-config`）；GPU、挂载点、快照分别在 `gpu.nix`、`mounts.nix`、`storage.nix` 调整。`~/Music` 要是独立子卷，Snapper 才能快照；`~/.cache` 子卷要手工建（见上文「`~/.cache` 子卷」）。
2. 用户名：`mopht` 写死在 `flake.nix`、`home/default.nix`、`home/misc.nix`（MPD 路径）、`home/shell/default.nix`（git 身份）、`system/core.nix`（含 UID）、`system/sops.nix`、`system/desktop/default.nix`（greetd）、`hosts/desktop/mounts.nix`、`hosts/desktop/storage.nix`。
3. 密钥：`nh os switch` 会卡在 `sops-install-secrets`。删掉 `system/sops.nix` 里的两个 secret 和 `hashedPasswordFile`（登录后自己 `passwd`，mpv 的 `blacklist_path` 相应去掉），或者把自己的 age 公钥加进 `.sops.yaml` 再 `sops updatekeys`（之后能解密你所有 secret）。
4. Hyprland 配置要 clone 到 `~/.config/hypr`，否则没键位；`~/.config/caelestia` 由 Home Manager 生成。
5. 个人项：`xdg.mimeApps`、防火墙端口、`home/apps/*` 的软件列表按需增删。

改完 `nh os switch`。

## Flatpak

| 应用 | 用途 |
|------|------|
| Flatseal | 权限管理 |
| QQ | 即时通讯 |
| WeChat | 即时通讯 |
| Spotify | 音乐 |

`uninstallUnmanaged = true`，没声明的 Flatpak 会被卸掉。所有应用通过全局 override 用 `Adwaita:dark`，光标为 Bibata 24px。

## 许可

个人配置，仅供参考。
