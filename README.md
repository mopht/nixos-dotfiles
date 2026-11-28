# NixOS 桌面配置

NixOS 桌面配置，系统与用户环境分别由 NixOS 模块和 Home Manager 声明，用 Flakes 组织。
Hyprland 的键位、窗口规则不在此仓库，见「项目结构」。

## 概览

| 项目 | 配置 |
|------|------|
| 操作系统 | NixOS unstable（26.11） |
| 包管理器 | Lix（Nix 分支） |
| 桌面环境 | Hyprland（Wayland） |
| Shell | Nushell；Fish 提供补全；Starship 做提示符 |
| 终端 | Kitty |
| 编辑器 | Neovim / Neovide / Helix |
| 浏览器 | Zen Browser |
| 输入法 | Fcitx5 + Rime（雾凇拼音） |
| 文件管理 | Nautilus / Superfile（TUI） |
| 媒体播放 | mpv（Anime4K）/ MPD + rmpc |
| 登录 | greetd + UWSM |
| 代理 | Clash Verge Rev |
| 密钥 | sops-nix（Age），密码 hash 与弹幕过滤表 |
| 主题 | Caelestia Shell / Papirus-Dark / Bibata |

## 硬件与存储

- CPU：Intel，支持 VT-x/KVM；未配置 libvirt/QEMU
- GPU：Intel Arc A750（`56a1`），`xe` 驱动，VA-API 硬解，含 32 位
- 内核：`linuxPackages_zen`
- 引导：systemd-boot，超时 1s，保留 10 个启动项，禁止编辑内核参数
- 交换：仅 zram（内存 25%，zstd），`vm.swappiness = 180`
- 根文件系统：Btrfs，`compress=zstd`、`noatime`、`discard=async`

### 分区

| 挂载点 | 类型 | 说明 |
|--------|------|------|
| `/` | Btrfs 子卷 `@` | 系统根目录 |
| `/home` | Btrfs 子卷 `@home` | 用户目录，参与 Snapper 快照 |
| `/boot` | VFAT | EFI 分区 |
| `~/Game` | Btrfs 顶层 | 游戏存储 |
| `~/Music` | Btrfs 子卷 `music` | 音乐，参与 Snapper 快照 |
| `~/.cache` | Btrfs 子卷 `@cache` | 缓存，不参与 `/home` 快照 |

### 快照与校验

- Snapper：`/home` 保留 5h/7d/2w/2m，`~/Music` 保留 2h/7d/2w/2m
- `~/.cache` 是独立子卷，缓存变化不会被算进 `/home` 快照
- autoScrub：每月一次，覆盖 `/`（含 `@home`）、`~/Game`、`~/Music`

## 项目结构

```
.
├── flake.nix                              # 入口，定义 inputs 与 outputs
├── flake.lock
├── .gitignore                             # result / *.hm-bak / .direnv
├── .sops.yaml                             # sops 加密规则与公钥
├── secrets/
│   └── secrets.yaml                       # Age 密文
│
├── hosts/
│   └── desktop/
│       ├── default.nix                    # 主机入口：内核、启动、zram、i2c
│       ├── gpu.nix                        # Intel Arc A750：xe、VA-API、32 位
│       ├── hardware.nix                   # nixos-generate-config 生成的分区
│       ├── mounts.nix                     # 手工维护的 ~/Game、~/Music、~/.cache
│       └── storage.nix                    # Snapper 与 btrfs autoScrub
│
├── system/
│   ├── core.nix                           # 时区、Lix、Nix 设置、用户
│   ├── pkgs.nix                           # 系统包、Flatpak、nix-ld
│   ├── sops.nix                           # sops-nix
│   ├── network.nix                        # 网络、防火墙、打印、代理
│   ├── desktop/
│   │   ├── default.nix                    # Hyprland、greetd、Portal、Sunshine
│   │   └── fcitx5.nix                     # Fcitx5 + Rime
│   └── hardware/
│       ├── audio.nix                      # PipeWire、MPD
│       ├── bluetooth.nix                  # 蓝牙、xpadneo
│       └── gaming.nix                     # Steam、Gamescope、Proton GE
│
└── home/
    ├── default.nix                        # 入口
    ├── pkgs.nix                           # 用户包、Flatpak、字体
    ├── misc.nix                           # KDE Connect、btop、nh、polkit、剪贴板
    ├── desktop/
    │   ├── caelestia.nix                  # Caelestia Shell、Gammastep
    │   ├── fcitx5.nix                     # 输入法 profile 与 rime 配置
    │   ├── fcitx5/                        # profile、default.custom.yaml
    │   └── theme.nix                      # GTK/Qt 主题、光标、暗色
    ├── shell/
    │   ├── default.nix                    # Nushell、Kitty、Zoxide、Eza、Starship
    │   └── starship.toml
    └── apps/
        ├── browser.nix                    # Zen Browser、ff2mpv
        ├── editor.nix                     # Helix、Lazygit
        ├── file-manager.nix               # Superfile
        └── media.nix                      # mpv、OBS、rmpc
```

Hyprland 配置在 [hyprland-dotfiles](https://github.com/mopht/hyprland-dotfiles)，需 clone 到 `~/.config/hypr`。
`~/.config/hypr/scheme/current.lua` 由 caelestia 换配色时生成，不入库。

## Flake 输入

| Input | 说明 |
|-------|------|
| [nixpkgs](https://github.com/NixOS/nixpkgs)（unstable） | 软件包源 |
| [home-manager](https://github.com/nix-community/home-manager) | 用户环境 |
| [nix-flatpak](https://github.com/gmodena/nix-flatpak) | 声明式 Flatpak |
| [moonbit-overlay](https://github.com/moonbit-community/moonbit-overlay) | MoonBit 工具链 |
| [caelestia-shell](https://github.com/caelestia-dots/shell) | Hyprland 桌面 Shell |
| [zen-browser](https://github.com/0xc000022070/zen-browser-flake) | Zen Browser |
| [sops-nix](https://github.com/Mic92/sops-nix) | Secrets（Age/sops） |

除 `nix-flatpak` 外，其余输入都 `follows` 本仓库的 nixpkgs。

## 系统维护

- `systemd-oomd`：内存压力高时终止进程
- `nix.optimise`：每周日 20:00 去重 store
- `fwupd`、`smartd`：固件更新、磁盘健康
- `udisks2`、`gvfs`：外置存储自动挂载
- polkit 代理 + GNOME Keyring：greetd 登录时由 PAM 解锁
- 剪贴板：cliphist（文本/图片）、wl-clip-persist、wl-clipboard
- 清理：`nix.gc` 每周删 14 天前的系统代；`nh clean` 保留 4 天/3 个用户代
- 日志：journald 持久化，上限 1G，`journalctl -b -1` 可查上次启动
- Nix：`trusted-users` 加 `mopht`，`substituters` 加 nix-community 缓存

## 桌面环境

- Hyprland + UWSM，greetd 以 `mopht` 自动登录；注销后会立即重新登录
- Caelestia Shell（Quickshell），配色由 caelestia 生成
- 输入法：Fcitx5 + Rime 雾凇拼音，profile 由 Home Manager 管理
- 主题：adw-gtk3-dark、qtengine + Darkly、Papirus-Dark、Bibata 24px
- 字体：Maple Mono NF CN / Cascadia Code，Source Han Sans / Noto Sans CJK，Noto Color Emoji；`fontconfig.defaultFonts` 固定中文/等宽/emoji 回退顺序
- 终端：Kitty，背景 0.45，行高 +7px，默认 Nushell
- 夜间：Gammastep 手动坐标，日 6500K / 夜 3500K
- 默认程序：`xdg.mimeApps`

## 应用

### 浏览器

- Zen Browser：`ff2mpv-rust` 可以把网页视频交由mpv播放
- 策略：禁遥测、Pocket、体验研究、内置更新
- 图形：Wayland 分数缩放、VA-API、WebRender
- container：Personal / Dev / Media
- 搜索关键字：`@nix`、`@opt`、`@gh`、`@b`

### 多媒体

- 音频：PipeWire，含 PulseAudio/ALSA 兼容
- MPD：PipeWire 输出，客户端 rmpc、go-musicfox
- mpv：Vulkan + Wayland + VA-API
  - Anime4K：L 档 `Ctrl+1/2/3`，VL 档 `Ctrl+5/6/7`，`Ctrl+0` 清除
  - 弹幕 uosc-danmaku，过滤表来自 sops（`/run/secrets/danmaku-filter`）；yt-dlp 复用 Zen 的 cookies
- swayimg：Lua 配置，画廊 `g`、幻灯片 `s`，`h`/`l` 切图，`Delete` 进回收站
- Loupe、EasyEffects、OBS（VA-API + wlrobs）、Nautilus（file-roller、ffmpegthumbnailer）
- Spotify：Flatpak

### 游戏

- Steam：Remote Play、Gamescope session
- Proton GE（`extraCompatPackages`）
- Gamescope `capSysNice`，GameMode
- Steam 手柄/VR 的 udev 规则
- umu-launcher、PrismLauncher

### 开发

| 语言 | 工具 |
|------|------|
| Rust | rustc, cargo, rust-analyzer |
| Haskell | GHC, cabal-install, HLS, cabal2nix |
| C/C++ | GCC, clang-tools, libc++, CMake, GDB |
| JS/TS | Node.js, Bun, esbuild, typescript-language-server |
| Nix | nixd, nixfmt |
| MoonBit | moonbit-bin（overlay） |
| Koka | koka, tree-sitter-koka |
| Idris 2 | idris2, idris2Lsp |
| Scheme | MIT/GNU Scheme, Guile, scheme-langserver, guile-lsp-server |
| Lua | lua-language-server |
| Python | python3（pillow, pillow-heif, rawpy, pyvips, pyzmq, python-pptx） |

- 默认编辑器：Neovim/Neovide（`$EDITOR`/`$VISUAL`）
- Helix：Everforest Dark，相对行号
- Lazygit、gh、Typora
- direnv + nix-direnv，进目录激活 Flake 环境并建 GC root
- clangd：C17 / C++26（libc++）

## 网络

- NetworkManager
- Clash Verge Rev：TUN + Service
- 蓝牙：Blueman、xpadneo
- KDE Connect：1714–1764
- LocalSend：53317（以上端口已在防火墙放行）
- Sunshine：按需启动，未开机自启
- usbmuxd、CUPS + Avahi

## 使用

### 首次部署

```bash
git clone https://github.com/mopht/nixos-dotfiles.git /etc/nixos
cd /etc/nixos
sudo nixos-rebuild switch --flake .#nixos
```

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
- `danmaku-filter`：mpv 弹幕过滤表，owner 为 `mopht`，路径 `/run/secrets/danmaku-filter`
- 编辑：`sops secrets/secrets.yaml`（默认读 `~/.config/sops/age/keys.txt`）
- sops-nix 开机时用 `/var/lib/sops-nix/key.txt` 解密；两个 key 都是 recipient，换机前都要备份

## 移植说明

1. 硬件：`hardware.nix` 的 UUID 换成本机的（`nixos-generate-config --show-hardware-config`）；GPU、挂载点、快照分别在 `gpu.nix`、`mounts.nix`、`storage.nix` 调整。`~/Music` 要是独立子卷，Snapper 才能快照。
2. 用户名：`mopht` 写死在 `flake.nix`、`home/default.nix`、`system/core.nix`（含 UID）、`system/sops.nix`、`system/hardware/audio.nix`、`hosts/desktop/storage.nix`。
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

所有应用通过全局 override 用 `Adwaita:dark`。

## 许可

个人配置，仅供参考。
