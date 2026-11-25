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
| **输入法** | Fcitx5 + Rime (雾凇拼音，profile 由 HM 管理) |
| **文件管理器** | Nautilus / Superfile (TUI) |
| **媒体播放器** | mpv (Anime4K) / MPD + rmpc |
| **登录管理器** | greetd + UWSM |
| **代理** | Clash Verge Rev |
| **密钥管理** | sops-nix (Age，用户密码 hash) |
| **主题** | Caelestia Shell / Papirus-Dark / Bibata 光标 |

## 🖥️ 硬件 & 系统维护

- **CPU**: Intel (VT-x/KVM 可用；未配置 libvirt/qemu)
- **GPU**: Intel Arc A750 (xe 驱动, `56a1`, VA-API 硬解，含 32 位)
- **内核**: Linux Zen
- **文件系统**: Btrfs (zstd 压缩, noatime, 异步 discard)
- **启动**: systemd-boot (UEFI, timeout 3s, 最多保留 10 个启动项, 禁止编辑内核参数)
- **交换**: zram (25%, zstd, `vm.swappiness=180`)
- **快照与自愈**:
  - Snapper (`/home`：5h/7d/2w/2m；`~/Music` 独立子卷：2h/7d/2w/2m；`~/.cache` 是独立子卷，不进 `/home` 快照)
  - Btrfs autoScrub (每月，覆盖 `/`（含 `@home`）、`~/Game`、`~/Music`)
- **系统保护 & 维护**:
  - systemd-oomd 内存压力保护（防重型编译卡死）
  - nix 存储去重改为定时任务 (`nix.optimise.automatic`)
  - fwupd 固件更新支持 + smartd 磁盘健康监控
  - udisks2 & gvfs 外部存储自动挂载
  - Polkit 认证代理 (hyprpolkitagent) 与 GNOME Keyring 凭据环 (greetd 自动解锁)
  - 剪贴板历史：cliphist (文本 + 图片) + wl-clipboard
  - Nix 旧代自动 GC：系统侧每周清理 14 天前 (`nix.gc`)，用户侧 `nh clean` 保留 4 天/3 个
  - journald 日志持久化 (上限 1G)，重启后仍可查上次启动的日志

### 分区布局

| 挂载点 | 文件系统 | 说明 |
|--------|---------|------|
| `/` | Btrfs `@` | 系统根目录 |
| `/home` | Btrfs `@home` | 用户目录 (Snapper 快照) |
| `/boot` | VFAT | EFI 启动分区 |
| `~/Game` | Btrfs (顶层) | 游戏存储 |
| `~/Music` | Btrfs 子卷 `music` | 音乐存储（Snapper 快照） |
| `~/.cache` | Btrfs 子卷 `@cache` | 缓存，不参与 `/home` 快照 |

## 📁 项目结构

```
.
├── flake.nix                              # Flake 入口，定义 inputs 和 outputs
├── flake.lock
├── .gitignore                             # 忽略 result / *.hm-bak / .direnv
├── .sops.yaml                             # sops 加密规则与公钥配置
├── secrets/                               # 加密密钥文件目录
│   └── secrets.yaml
│
├── hosts/
│   └── desktop/
│       ├── default.nix                    # 主机入口 (内核、启动、zram、i2c)
│       ├── gpu.nix                        # Intel Arc A750 (xe 驱动、VA-API、32 位硬解)
│       ├── hardware.nix                   # nixos-generate-config 生成的分区/微码
│       ├── mounts.nix                     # 手工维护的 ~/Game、~/Music 挂载点
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
    ├── misc.nix                           # KDE Connect + btop + nh + polkit + 剪贴板
    ├── desktop/
    │   ├── caelestia.nix                  # Caelestia Shell + Gammastep
    │   ├── fcitx5.nix                     # 输入法 profile + rime schema (HM 管理)
    │   ├── fcitx5/                        # profile / default.custom.yaml 数据文件
    │   └── theme.nix                      # GTK/Qt 主题、光标、暗色模式
    ├── shell/
    │   ├── default.nix                    # Nushell + Kitty + Zoxide + Eza + Starship
    │   └── starship.toml                  # Starship 配置 (仓库内，只读链接)
    └── apps/
        ├── browser.nix                    # Zen Browser (ff2mpv)
        ├── editor.nix                     # Helix + Lazygit
        ├── file-manager.nix               # Superfile
        └── media.nix                      # mpv (Anime4K) + OBS + rmpc
```

> **Hyprland 配置不在此仓库**：键位、窗口规则、变量和配色生成在
> [hyprland-dotfiles](https://github.com/mopht/hyprland-dotfiles)，需要 `git clone` 到 `~/.config/hypr`。
> `~/.config/hypr/scheme/current.lua` 由 caelestia 换配色时自动生成，不纳入任何仓库。

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
- **GameMode** — `gamemoderun` 游戏优化，配合 Steam 手柄/VR 的 udev 规则
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
  - 快捷键：`h`/`l` 上一张/下一张 (Gallery 内 `h/j/k/l` 选择)、`Space` 下一张、`r`/`R` 旋转、`i` 元信息 HUD
  - `trash-cli` 联动（按 `Delete` 安全移入系统回收站）
- **Loupe** — GNOME 现代看图工具
- **EasyEffects** — 麦克风降噪 / 耳机 EQ (PipeWire)
- **OBS Studio** — 录屏/直播 (VA-API + wlrobs)
- **Nautilus** — 配合 file-roller (压缩包) 与 ffmpegthumbnailer (视频缩略图)
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

- **Neovim / Neovide** — 主力编辑器（登录会话默认 `$EDITOR` 与 `$VISUAL`）
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
- **Sunshine** — 远程串流 (按需启动，未设为开机自启)
- **usbmuxd** — iOS 设备连接
- **打印** — CUPS + Avahi (mDNS)

## 🎨 外观与体验

- **Shell**: Caelestia (基于 Quickshell 的 Hyprland 桌面 Shell)
- **GTK 主题**: adw-gtk3-dark (caelestia 生成 `gtk.css` + dconf `prefer-dark`)
- **Qt 主题**: qtengine + Darkly（caelestia 生成配色）
- **图标**: Papirus-Dark
- **光标**: Bibata-Modern-Classic (24px)
- **剪贴板**: cliphist 历史 (文本/图片)、wl-clip-persist 常驻、wl-clipboard 提供 `wl-copy`/`wl-paste`
- **字体**:
  - 等宽代码: Maple Mono NF CN (终端斜体 + 7px行高微调) / Cascadia Code
  - 正文字体: Source Han Sans (思源黑体) / Noto Sans CJK
  - 彩色表情: Noto Color Emoji (彻底解决终端与网页 Emoji 豆腐块)
- **终端风格**: Kitty (0.45 半透明、枫叶单宽字体、光标动效、NuShell 专属补全)
- **夜间护眼**: Gammastep (手动坐标，日间 6500K / 夜间 3500K 自动平滑过渡；`services.geoclue2` 虽启用但目前未使用)
- **默认程序**: `xdg.mimeApps` 声明 (浏览器/图片/视频/压缩包/磁力/目录)
- **字体回退**: `fontconfig.defaultFonts` 固定中文/等宽/emoji 顺序

## 🚀 使用方法

### 首次部署

```bash
# 克隆配置
git clone https://github.com/mopht/nixos-dotfiles.git /etc/nixos
cd /etc/nixos

# 构建并切换
sudo nixos-rebuild switch --flake .#nixos
```

### 关于 `~/Music` 的快照（2026-11-25 已迁移）

`~/Music` 原来挂在 btrfs 顶层 subvolume（`subvolid=5`），而 btrfs 不能对顶层做快照，
Snapper 的 `music` 配置因此一直没生效。现在已迁移到独立子卷 `music`（`mounts.nix` 里
`subvol=music`），迁移时因为分区空间不足以整份复制，是用 `rsync --remove-source-files`
边搬边删完成的。

换机/重装时如果要复刻：先 `btrfs subvolume create` 出 `music` 子卷，把数据搬进去，
再改用 `subvol=music` 挂载，并一次性建好 Snapper 需要的 `.snapshots` 子卷
（NixOS 模块不会自动创建它）：

```bash
sudo btrfs subvolume create /home/mopht/Music/.snapshots
```

### `~/.cache` 独立子卷（一次性）

为了让 `/home` 的 hourly 快照不把 6G+ 缓存一起快照，`~/.cache` 挂在 `@cache` 子卷上。
首次启用前需要先建子卷（子卷根默认 root:root，由 tmpfiles 规则改成 `mopht`）：

```bash
# 1) 在 @home 所在的文件系统上建 @cache 子卷
sudo mkdir -p /mnt/bt
sudo mount -o subvolid=5 /dev/disk/by-uuid/bdaa131f-07d1-419c-b593-4783d11e0b43 /mnt/bt
sudo btrfs subvolume create /mnt/bt/@cache
sudo umount /mnt/bt && sudo rmdir /mnt/bt

# 2) 旧缓存挪开（同一子卷内 rename，瞬时完成）
mv /home/mopht/.cache /home/mopht/.cache-old

# 3) 应用配置：~/.cache 会挂上空的新子卷
sudo nixos-rebuild switch --flake /etc/nixos#nixos

# 4) 首次挂载后子卷根还是 root:root（tmpfiles 要等下次开机才会改），先手动修一次
sudo chown mopht:users /home/mopht/.cache
sudo chmod 700 /home/mopht/.cache

# 5) 确认没问题后删掉旧缓存
rm -rf /home/mopht/.cache-old
```

> 缓存目录是随时可以重建的；如果应用出现异常，把旧目录移回来即可。

### 日常更新

本配置集成了 [nh](https://github.com/viperML/nh) 进行便捷管理：

```bash
# 更新 flake inputs
nix flake update

# 大更新（内核/nixpkgs）建议先 boot，重启验证后再 switch：
#   nh os boot   # 只设为下次启动，不切换
#   nh os switch # 构建并立即切换
#   nh os rollback
nh os switch

# 自动清理：用户侧 nh clean (保留 4 天内 / 最近 3 个)
#           系统侧 nix.gc 每周清理 14 天前的 generation
# 提交前构建校验 (系统 + Home Manager 都会实际构建)
nix flake check
```

> 新增的配置文件需要先 `git add`，否则 flake 看不到它们。

### 格式化配置文件

```bash
nix fmt
```

## 🔐 密钥管理

使用 [sops-nix](https://github.com/Mic92/sops-nix) 管理敏感数据，密文存放在 `secrets/secrets.yaml`（Age 加密）。

> 目前只声明了 `mopht-passwd` 一个 secret，用于 `users.users.mopht.hashedPasswordFile`
> （`secrets/secrets.yaml` 里还有一个残留的 `example_key`，没有引用，可以删掉）；
> Age 私钥在仓库外的 `/var/lib/sops-nix/key.txt`（root 所有），**换机/重装前必须单独备份**，
> 丢了就解不开 `secrets/secrets.yaml`。

## 🔁 给其他人用 / 二次开发

这套配置是围绕作者这台机器写的，直接拿到别的机器上 `nh os switch` 会失败或不合预期。要改的地方：

1. **硬件**：`hosts/desktop/hardware.nix` 里的分区 UUID 只属于这台机器，用
   `nixos-generate-config --show-hardware-config` 重新生成后替换；GPU、挂载点和快照配置分别在
   `hosts/desktop/gpu.nix`、`hosts/desktop/mounts.nix`、`hosts/desktop/storage.nix`，按实际硬件调整。
   `~/Music` 需要是独立 btrfs 子卷（`subvol=music`）Snapper 才能快照。
2. **用户名**：`mopht` 是硬编码的，至少改：
   `flake.nix` 的 `home-manager.users.mopht`、`home/default.nix` 的 `home.username`/`homeDirectory`、
   `system/core.nix` 的 `users.users.mopht`、`system/sops.nix` 的 age key 路径、
   `system/hardware/audio.nix` 的 MPD 路径、`hosts/desktop/storage.nix` 的 `ALLOW_USERS`。
3. **密钥 (sops)**：`secrets/secrets.yaml` 是用作者的 age 公钥加密的，`nh os switch`
   会卡在 `sops-install-secrets` ：
   - **删掉** `system/sops.nix` 里的 `sops.secrets.mopht-passwd` 和 `hashedPasswordFile`，
     首次登录后自己 `passwd`；
   - 或把自己的 age 公钥加进 `.sops.yaml` 再 `sops updatekeys secrets/secrets.yaml`
     （注意这样对方能解开你的**所有** secret）。
   即使能解密，首次创建用户时用的也是作者的密码 hash；之后 `passwd` 改成自己的即可
   （NixOS 默认 `mutableUsers = true`，重建不会把密码改回去）。
4. **Hyprland 配置**不在本仓库：需要 `git clone https://github.com/mopht/hyprland-dotfiles.git ~/.config/hypr`，
   否则桌面没有键位；`~/.config/caelestia` 由 Home Manager 生成。
5. **个人项**：`home/misc.nix` 的 `xdg.mimeApps` 引用了第三方应用，
   没有对应程序时关联会失效；`system/network.nix` 的防火墙端口、`home/apps/*` 的软件列表按需删减。

改完后 `nh os switch`

## 📦 Flatpak 应用

通过 `nix-flatpak` 声明式管理：

- **Flatseal** — Flatpak 权限管理
- **QQ** — 即时通讯
- **WeChat** — 微信
- **Spotify** — 音乐流媒体

> 所有 Flatpak 应用强制使用 `Adwaita:dark` GTK 主题。

## 📝 License

个人配置，仅供参考。
