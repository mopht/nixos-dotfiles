# ❄️ NixOS Configuration

我的 NixOS 桌面配置，基于 Nix Flakes 和 Home Manager 进行声明式系统管理。

## 📋 系统概览

| 项目 | 配置 |
|------|------|
| **OS** | NixOS Unstable (26.11) |
| **包管理器** | Lix (Nix fork) |
| **桌面环境** | Hyprland (Wayland) |
| **Shell** | Nushell + Fish (补全) + Starship |
| **终端** | Kitty |
| **编辑器** | Helix / Neovim / Neovide |
| **浏览器** | Zen Browser |
| **输入法** | Fcitx5 + Rime (雾凇拼音) |
| **文件管理器** | Nautilus / Superfile (TUI) |
| **媒体播放器** | mpv (Anime4K) / MPD + rmpc |
| **登录管理器** | greetd + UWSM |
| **代理** | Clash Verge Rev |
| **主题** | Caelestia Shell / Papirus-Dark / Bibata 光标 |

## 🖥️ 硬件

- **CPU**: Intel (支持 KVM 虚拟化)
- **GPU**: Intel Arc (xe 驱动, `56a1`)
- **内核**: Linux Zen
- **文件系统**: Btrfs (zstd 压缩, noatime, 异步 discard)
- **启动**: systemd-boot (UEFI)
- **交换**: zram (25%, zstd)
- **快照**: Snapper (hourly, 自动清理)

### 分区布局

| 挂载点 | 文件系统 | 说明 |
|--------|---------|------|
| `/` | Btrfs `@` | 系统根目录 |
| `/home` | Btrfs `@home` | 用户目录 (Snapper 快照) |
| `/boot` | VFAT | EFI 启动分区 |
| `~/Game` | Btrfs | 游戏存储 |
| `~/Music` | Btrfs | 音乐存储 |

## 📁 项目结构

```
.
├── flake.nix                              # Flake 入口，定义 inputs 和 outputs
├── flake.lock
│
├── hosts/
│   └── desktop/
│       ├── default.nix                    # 主机入口 (内核、启动、zram、i2c)
│       └── hardware.nix                   # 硬件配置 (分区、GPU、Snapper 快照)
│
├── system/                                # 系统级模块
│   ├── core.nix                           # 核心设置 (时区、Lix、用户)
│   ├── pkgs.nix                           # 系统软件包 + Flatpak + nix-ld
│   ├── network.nix                        # 网络、防火墙、打印、代理
│   ├── desktop/
│   │   ├── default.nix                    # Hyprland + greetd + XDG Portal + Sunshine
│   │   └── fcitx5.nix                     # 输入法 (Fcitx5 + Rime 雾凇拼音)
│   └── hardware/
│       ├── audio.nix                      # PipeWire + MPD
│       ├── bluetooth.nix                  # 蓝牙 + xpadneo
│       └── gaming.nix                     # Steam + Gamescope + Proton GE
│
└── home/                                  # Home Manager 用户配置
    ├── default.nix                        # Home Manager 入口
    ├── pkgs.nix                           # 用户软件包 + Flatpak + 字体
    ├── misc.nix                           # KDE Connect + btop + nh + clangd
    ├── desktop/
    │   ├── caelestia.nix                  # Caelestia Shell + Gammastep
    │   └── theme.nix                      # GTK/Qt 主题、光标、暗色模式
    ├── shell/
    │   └── default.nix                    # Nushell + Kitty + Zoxide + Eza + Starship
    └── apps/
        ├── browser.nix                    # Zen Browser (ff2mpv)
        ├── editor.nix                     # Helix + Lazygit
        ├── file-manager.nix               # Superfile
        └── media.nix                      # mpv (Anime4K) + OBS + rmpc
```

## 🔧 Flake Inputs

| Input | 说明 |
|-------|------|
| [nixpkgs](https://github.com/NixOS/nixpkgs) (unstable) | 核心软件包源 |
| [home-manager](https://github.com/nix-community/home-manager) | 声明式用户环境管理 |
| [nix-flatpak](https://github.com/gmodena/nix-flatpak) | 声明式 Flatpak 管理 |
| [moonbit-overlay](https://github.com/moonbit-community/moonbit-overlay) | MoonBit 语言工具链 |
| [caelestia-shell](https://github.com/caelestia-dots/shell) | Hyprland 桌面 Shell 组件 |
| [zen-browser](https://github.com/0xc000022070/zen-browser-flake) | Zen Browser (Firefox fork) |

## 🎮 游戏

- **Steam** — 启用 Remote Play，集成 Gamescope session
- **Proton GE** — 额外兼容层
- **Gamescope** — 支持 `capSysNice`
- **umu-launcher** — 非 Steam 游戏启动器
- **PrismLauncher** — Minecraft 启动器

## 🎵 多媒体

- **PipeWire** — 音频服务 (PulseAudio + ALSA 兼容)
- **MPD** — 音乐守护进程，PipeWire 输出
- **rmpc** — MPD TUI 客户端
- **go-musicfox** — 网易云音乐 TUI
- **mpv** — 视频播放器
  - Vulkan + Wayland + VA-API 硬解
  - Anime4K 着色器 (L / VL 两档，各含 Balanced / Sharp / Denoise 模式)
    - `Ctrl+1/2/3` — L 档 (720p→1080p)
    - `Ctrl+5/6/7` — VL 档 (720p→1080p)
    - `Ctrl+0` — 清除着色器
  - 弹幕支持 (uosc-danmaku)
  - yt-dlp 集成 (Zen Browser cookies)
- **OBS Studio** — 录屏/直播 (VA-API + wlrobs)
- **Spotify** — 通过 Flatpak 安装

## 💻 开发环境

### 语言 & 工具链

| 语言 | 工具 |
|------|------|
| Rust | rustc, cargo, rust-analyzer |
| Haskell | GHC, cabal, HLS, cabal2nix |
| C/C++ | GCC, Clang tools, libc++, CMake, GDB |
| JavaScript/TypeScript | Node.js, Bun, esbuild, TS LSP |
| Nix | nixd, nixpkgs-fmt |
| MoonBit | moonbit-bin (via overlay) |
| Koka | koka, tree-sitter-koka |
| Idris 2 | idris2, idris2Lsp |
| Scheme | MIT/GNU Scheme, Guile, scheme-langserver, guile-lsp-server |
| Lua | lua-language-server |
| Python | python3 (pillow, rawpy, vips, pyzmq, python-pptx…) |

### 开发工具

- **Neovim / Neovide** — 主力编辑器 (配合 tree-sitter)
- **Helix** — 轻量编辑器 (Everforest Dark 透明主题, 相对行号)
- **Lazygit** — Git TUI
- **gh** — GitHub CLI
- **direnv** — 自动加载项目环境
- **clangd** — C/C++ LSP (C17 / C++26 / libc++)
- **Typora** — Markdown 编辑器

## 🌐 网络 & 连接

- **NetworkManager** — 网络管理
- **Clash Verge Rev** — 代理 (TUN 模式 + Service 模式)
- **蓝牙** — 启用 (Blueman, xpadneo 手柄支持)
- **KDE Connect** — 手机联动 (端口 1714-1764)
- **LocalSend** — 局域网传输 (端口 53317)
- **Sunshine** — 远程串流
- **usbmuxd** — iOS 设备连接
- **打印** — CUPS + Avahi (mDNS)

## 🎨 外观

- **Shell**: Caelestia (Hyprland AGS Shell)
- **GTK 主题**: Adwaita Dark
- **Qt 主题**: Kvantum + qt6ct
- **图标**: Papirus-Dark
- **光标**: Bibata-Modern-Classic (24px)
- **字体**: Maple Mono NF CN (终端) / Source Han Sans / Noto CJK / Cascadia Code
- **终端透明度**: 0.45
- **色温**: Gammastep (日间 6500K / 夜间 3500K, GeoClue2 自动)

## 🚀 使用方法

### 首次部署

```bash
# 克隆配置
git clone https://github.com/mopht/nixos-dotfiles.git /etc/nixos
cd /etc/nixos

# 构建并切换
sudo nixos-rebuild switch --flake .#nixos
```

### 日常更新

本配置集成了 [nh](https://github.com/viperML/nh) 进行便捷管理：

```bash
# 更新 flake inputs
nix flake update

# 构建并切换 (通过 nh)
nh os switch

# 自动清理旧 generation (保留 4 天内 / 最近 3 个)
# nh clean 已配置自动运行
```

### 格式化配置文件

```bash
nix fmt
```

## 📦 Flatpak 应用

通过 `nix-flatpak` 声明式管理：

- **Flatseal** — Flatpak 权限管理
- **QQ** — 即时通讯
- **WeChat** — 微信
- **Spotify** — 音乐流媒体

> 所有 Flatpak 应用强制使用 `Adwaita:dark` GTK 主题。

## 📝 License

个人配置，仅供参考。
