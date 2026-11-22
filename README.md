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
| **密钥管理** | sops-nix (Age) |
| **主题** | Caelestia Shell / Papirus-Dark / Bibata 光标 |

## 🖥️ 硬件 & 系统维护

- **CPU**: Intel (支持 KVM 虚拟化)
- **GPU**: Intel Arc (xe 驱动, `56a1`, VA-API 硬件加速)
- **内核**: Linux Zen
- **文件系统**: Btrfs (zstd 压缩, noatime, 异步 discard)
- **启动**: systemd-boot (UEFI, timeout 1s)
- **交换**: zram (25%, zstd)
- **快照与自愈**:
  - Snapper (hourly, 自动清理保留)
  - Btrfs autoScrub (每月自动静默数据校验)
- **系统保护 & 维护**:
  - systemd-oomd 内存压力保护（防重型编译卡死）
  - nix 存储自动硬链接去重 (`auto-optimise-store`)
  - fwupd 固件更新支持
  - udisks2 & gvfs 外部存储自动挂载
  - Polkit 认证代理与 GNOME Keyring 凭据环 (greetd 自动解锁)

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
├── .sops.yaml                             # sops 加密规则与公钥配置
├── secrets/                               # 加密密钥文件目录
│   └── secrets.yaml
│
├── hosts/
│   └── desktop/
│       ├── default.nix                    # 主机入口 (内核、启动、zram、i2c)
│       ├── gpu.nix                        # Intel Arc A750 (xe 驱动、VA-API、32 位硬解)
│       ├── hardware.nix                   # nixos-generate-config 生成的分区/微码
│       └── storage.nix                    # Snapper 快照 + btrfs autoScrub
│
├── system/                                # 系统级模块
│   ├── core.nix                           # 核心设置 (时区、Lix、用户)
│   ├── pkgs.nix                           # 系统软件包 + Flatpak + nix-ld
│   ├── sops.nix                           # sops-nix 密钥管理
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
| [sops-nix](https://github.com/Mic92/sops-nix) | 声明式 Secrets 密钥管理 (Age / Sops) |

## 🎮 游戏

- **Steam** — 启用 Remote Play，集成 Gamescope session
- **Proton GE** — 额外兼容层
- **Gamescope** — 支持 `capSysNice`
- **umu-launcher** — 非 Steam 游戏启动器
- **PrismLauncher** — Minecraft 启动器

## 🎵 多媒体与视听

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
  - yt-dlp 集成 (Zen Browser cookies 联动)
- **swayimg** — Wayland 原生极速图片查看器
  - Lua 声明式定制，无窗体边框、自适应平滑缩放
  - 支持画廊（Gallery）九宫格矩阵与幻灯片模式 (`g` / `s`)
  - Vim 快捷键 (`h/j/k/l`、`Space`、`r` 旋转、`i` 元信息 HUD)
  - `trash-cli` 联动（按 `Delete` 安全移入系统回收站）
- **Loupe** — GNOME 现代看图工具
- **OBS Studio** — 录屏/直播 (VA-API + wlrobs)
- **Spotify** — 通过 Flatpak 安装

## 🌐 浏览器 (Zen Browser)

- **原生视频调用**：集成 `ff2mpv-rust`，网页视频快捷调起 mpv 播放
- **隐私加固策略**：禁用 Telemetry 遥测、Pocket、体验研究与内置升级
- **图形与硬解优化**：Wayland 分数缩放、VA-API 硬件解码与 WebRender 全开
- **多账号环境隔离**：配置 `Personal`、`Dev`、`Media` 专属容器
- **快捷搜索引擎**：
  - `@nix` — Nix Packages 搜索
  - `@opt` — NixOS Options 选项搜索
  - `@gh` — GitHub 代码搜索
  - `@b` — 哔哩哔哩视频搜索

## 💻 开发环境

### 语言 & 工具链

| 语言 | 工具 |
|------|------|
| Rust | rustc, cargo, rust-analyzer |
| Haskell | GHC, cabal, HLS, cabal2nix |
| C/C++ | GCC, Clang tools, libc++, CMake, GDB |
| JavaScript/TypeScript | Node.js, Bun, esbuild, TS LSP |
| Nix | nixd, nixfmt |
| MoonBit | moonbit-bin (via overlay) |
| Koka | koka, tree-sitter-koka |
| Idris 2 | idris2, idris2Lsp |
| Scheme | MIT/GNU Scheme, Guile, scheme-langserver, guile-lsp-server |
| Lua | lua-language-server |
| Python | python3 (pillow, rawpy, vips, pyzmq, python-pptx…) |

### 开发工具

- **Neovim / Neovide** — 主力编辑器（设为系统全局默认 `$EDITOR` 与 `$VISUAL`）
- **Helix** — 轻量编辑器 (Everforest Dark 透明主题, 相对行号)
- **Lazygit** — Git TUI
- **gh** — GitHub CLI
- **direnv + nix-direnv** — 瞬时激活项目 Flake 环境，自动创建 GC Root 避免重复下载
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

## 🎨 外观与体验

- **Shell**: Caelestia (Hyprland AGS Shell)
- **GTK 主题**: Adwaita Dark
- **Qt 主题**: qtengine + Darkly（caelestia 生成配色）
- **图标**: Papirus-Dark
- **光标**: Bibata-Modern-Classic (24px)
- **字体**:
  - 等宽代码: Maple Mono NF CN (终端斜体 + 7px行高微调) / Cascadia Code
  - 正文字体: Source Han Sans (思源黑体) / Noto Sans CJK
  - 彩色表情: Noto Color Emoji (彻底解决终端与网页 Emoji 豆腐块)
- **终端风格**: Kitty (0.45 半透明、枫叶单宽字体、光标动效、NuShell 专属补全)
- **夜间护眼**: Gammastep (GeoClue2 定位，日间 6500K / 夜间 3500K 自动平滑过渡)

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

## 🔐 密钥管理

使用 [sops-nix](https://github.com/Mic92/sops-nix) 进行声明式敏感数据管理，密钥文件基于 Age 加密存放在 `secrets/secrets.yaml`，系统运行时自动解密挂载于 `/run/secrets/`。

## 📦 Flatpak 应用

通过 `nix-flatpak` 声明式管理：

- **Flatseal** — Flatpak 权限管理
- **QQ** — 即时通讯
- **WeChat** — 微信
- **Spotify** — 音乐流媒体

> 所有 Flatpak 应用强制使用 `Adwaita:dark` GTK 主题。

## 📝 License

个人配置，仅供参考。
