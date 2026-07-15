# ❄️ NixOS Configuration

My personal NixOS configuration, featuring Caelestia shell on Hyprland with a focus on aesthetics, performance, and reproducibility.

## 📸 Overview

- **OS**: NixOS (unstable)
- **WM**: Hyprland
- **Shell**: Caelestia
- **Terminal**: Kitty
- **Editor**: Neovim / Neovide
- **Browser**: Zen Browser
- **Font**: Maple Mono NF / Maple Mono NF CN
- **Icons**: Papirus
- **Cursor**: Bibata Modern Classic

## 🗂️ Structure

```
nixos-config/
├── flake.nix                  # Flake entry point
├── flake.lock                 # Locked dependencies
├── hosts/
│   └── desktop/
│       ├── configuration.nix  # System configuration
│       └── hardware.nix       # Hardware configuration
├── modules/                   # System-level modules
│   ├── pkgs.nix               # System packages
│   ├── desktop.nix            # Hyprland, display
│   ├── network.nix            # mihomo, NetworkManager
│   ├── audio.nix              # PipeWire, MPD
│   ├── gaming.nix             # Steam, gamescope
│   └── fcitx5.nix             # Just fcitx5
└── home/                      # Home Manager modules
    ├── home.nix               # HM entry point
    ├── pkgs.nix               # User packages
    ├── fish.nix               # Fish shell
    ├── display.nix            # Qt/Gtk Theme
    ├── caelestia.nix          # Caelestia shell
    └── misc.nix               # Others (links to submodule)
```

## ✨ Features

- **Caelestia shell** — fluid animations, wallpaper-based color extraction, Material You color system
- **Hyprland** — scrolling layout, spring physics animations, Lua configuration
- **Clash-Verge-Rev** — transparent proxy
- **MPD + MPRIS** — music playback with mpdris2-rs bridge for media controls
- **fcitx5 + Rime** — Chinese input with 雾凇拼音
- **Steam + Gamescope** — gaming with FSR upscaling support
- **Btrfs** — zstd compression, subvolume layout

## 🚀 Installation

### Prerequisites

- NixOS installed with Flakes enabled
- Home manager
- Git

### Deploy

```bash
# Clone the repository
git clone https://github.com/mopht/nixos-config ~/nixos-config
cd ~/nixos-config

# Deploy system/home-manager configuration
sudo nixos-rebuild switch

```

### On a new machine

```bash
# Clone and apply in one step
sudo nixos-rebuild switch --flake github:你的用户名/nixos-config#desktop
```

## 🔄 Updating

```bash
# Update all flake inputs
nix flake update

# Rebuild
sudo nixos-rebuild switch
```

## 🎨 Wallpaper & Color Scheme

Caelestia uses its own color generator (not matugen). To set wallpaper and apply dynamic colors:

```bash
# Set wallpaper and extract colors
caelestia wallpaper -f ~/Pictures/Wallpapers/wallpaper.jpg

# Switch to dynamic color scheme
caelestia scheme set -n dynamic
```

Custom user configuration goes in `./home/caelestia.nix`.

## 🎮 Gaming

Steam is configured with:
- Proton GE for better game compatibility
- Gamescope for FSR upscaling and scheduling priority
- 32-bit library support

To use FSR upscaling, add to Steam launch options:

```
gamescope -W 2560 -H 1600 -r 120 --fsr-upscaling -- %command%
```

## 🎵 Music

MPD is configured as a system service with PipeWire output.
MPRIS bridge via mpdris2-rs allows media key control and Caelestia media widget integration.

```bash
rmpc
```

## 📦 Key Packages

| Category | Packages |
|----------|---------|
| Shell | fish, carapace, zoxide, fzf |
| Editor | neovim, neovide, tree-sitter |
| Terminal | kitty |
| Files | yazi, nautilus, superfile |
| Media | mpd, mpc, mpdris2-rs, cava |
| Proxy | clash-verge |
| Gaming | steam, gamescope, proton-ge |
| Utils | eza, fastfetch |

<!-- ## 🖥️ Hardware -->
<!---->
<!-- - **CPU**: Intel Core i3-12100F -->
<!-- - **GPU**: Intel Arc A750 -->
<!-- - **RAM**: 16GB DDR4 -->
<!-- - **Storage**: 476GB (system) + 160GB (games) + 60GB (music) -->

## 📝 Notes

- Neovim configuration is maintained as a separate repository and linked via Home Manager
- Windows games migrated from other systems require fresh Proton prefix (delete `~/.steam/steam/steamapps/compatdata/<AppID>/`)
- Intel Arc A750 performs better with OpenGL than Vulkan on Linux due to Mesa driver limitations (known issue)

## 🙏 Credits

- [Caelestia](https://github.com/caelestia-dots/shell) — shell and color system
- [end-4](https://github.com/end-4/dots-hyprland) — Hyprland configuration inspiration
- [Quickshell](https://quickshell.org) — shell framework
