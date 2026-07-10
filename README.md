# VEX-PKG Tools v4.0.3

<div align="center">
  <img src="https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white" alt="Arch">
  <img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Bash">
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/badge/Version-4.0.3-red?style=for-the-badge" alt="Version">
</div>

---

## Ultimate Arch Linux Toolkit Installer

VEX-PKG is an all-in-one toolkit that transforms your Arch Linux system with 15 categories, 300+ packages, 10 beautiful themes, and automated configurations for Kitty, Fish, Fastfetch, GNOME, and more.

---

## Features

### 15 Package Categories

| Category | Packages | Description |
|----------|----------|-------------|
| Core | 16 | Essential system packages |
| Base | 29 | Core utilities |
| Desktop | 16 | GNOME environment |
| Development | 29 | Programming tools |
| Pentest-Light | 40 | Essential security tools |
| Pentest-Pro | 300+ | Advanced security toolkit (11 subcategories) |
| Gaming | 11 | Gaming & entertainment |
| Media | 17 | Multimedia & creative tools |
| Network | 14 | Networking & communication |
| Privacy | 37 | Privacy & security tools |
| AUR | 18 | Arch User Repository packages |
| GPU | 15 | Graphics drivers |
| Downloaders | 15 | Download managers |
| Fun-Tools | 14 | Entertainment & fun |

### 10 Stunning Themes

- Red & White - Classic VEX theme
- Cyberpunk - Neon futuristic
- Nord - Cool and calm
- Dracula - Dark and vibrant
- Tokyo Night - Neon city lights
- Catppuccin - Warm and cozy
- Gruvbox - Retro and warm
- Solarized - Easy on the eyes
- Everforest - Nature inspired
- Rose Pine - Soft and elegant

### Pentest-Pro: 11 Subcategories

- **Recon** - 60+ tools (nmap, masscan, amass, subfinder...)
- **Web** - 80+ tools (sqlmap, ffuf, gobuster, nuclei...)
- **Exploit** - 40+ tools (metasploit, exploitdb, bloodhound...)
- **Network** - 35+ tools (wireshark, tcpdump, ettercap...)
- **Credential** - 30+ tools (hashcat, john, hydra...)
- **Social** - 20+ tools (bettercap, gophish, hiddeneye...)
- **C2** - 25+ tools (proxychains, tor, wireguard...)
- **Wireless** - 25+ tools (aircrack-ng, airgeddon, wifite...)
- **Privesc** - 25+ tools (linpeas, winpeas, pspy...)
- **OSINT** - 30+ tools (maigret, holehe, photon...)
- **Serialization** - 15+ tools (phpggc, ysoserial...)

### Powerful Modules

- GNOME Setup - Extensions, icons, cursors, settings
- Configs - Fastfetch, Kitty, Fish configurations
- GPU Drivers - NVIDIA, AMD, Intel automatic detection
- Services - NetworkManager, sshd, bluetooth, cups
- Mirrors - Fastest pacman mirrors
- AUR - Yay installation
- Fun Tools - cowsay, figlet, cmatrix, lolcat, and more

---

## Quick Installation

```bash
curl -L -o install.sh https://raw.githubusercontent.com/VexisVX/VEX-PKG/main/install.sh
chmod +x install.sh
sudo bash install.sh
```

### What happens during installation?

1. Checks for Arch Linux
2. Optionally sets up Reflector (fastest mirrors)
3. Optionally adds BlackArch repository
4. Creates VEX structure
5. Installs 15 package categories
6. Applies your chosen theme
7. Configures Kitty, Fish, Fastfetch
8. Installs vex-pkg with auto-completion

---

## VEX Package Manager (vex-pkg)

```bash
# List all categories
vex-pkg list

# Show packages in a category
vex-pkg show Core
vex-pkg show Pentest-Pro

# Install a package
sudo vex-pkg install kitty

# Install a whole category
sudo vex-pkg install desktop (*note the lowercase)

# Install multiple packages
sudo vex-pkg install kitty fish fastfetch

# Apply configurations
sudo vex-pkg apply configs
sudo vex-pkg apply gnome

# System health check
sudo vex-pkg doctor

# Full help
vex-pkg help
```

---

## Manual Commands

### Package Management

```bash
vex-pkg list                     # Show all categories
vex-pkg show <category>          # Show packages in category
vex-pkg show Pentest-Pro <sub>   # Show Pentest-Pro subcategory
sudo vex-pkg install <category>  # Install a whole category
sudo vex-pkg install <pkg>       # Install a specific package
sudo vex-pkg info <pkg>          # Show package information
sudo vex-pkg search <query>      # Search for packages
```

### System Configuration

```bash
sudo vex-pkg apply gnome         # Setup GNOME extensions & themes
sudo vex-pkg apply configs       # Apply Fastfetch, Kitty, Fish configs
sudo vex-pkg apply gpu           # Install GPU drivers
sudo vex-pkg apply services      # Enable system services
sudo vex-pkg apply fun           # Install fun tools
sudo vex-pkg apply mirrors       # Configure pacman mirrors
```

### Utilities

```bash
sudo vex-pkg install-yay         # Install yay (AUR helper)
sudo vex-pkg install-all         # Install all categories
sudo vex-pkg doctor              # System health check
sudo vex-pkg cleanup             # Clean package caches
```

---

## Directory Structure

```
/usr/share/vex/
├── config/
│   ├── kitty/           # Kitty terminal config
│   ├── fish/            # Fish shell config
│   ├── fastfetch/       # Fastfetch config
│   ├── gnome/           # GNOME extensions & settings
│   └── gpu/             # GPU drivers list
├── lib/
│   ├── core/            # Core functions
│   └── modules/         # Configuration modules
├── packages-lists/      # 15 category package lists
└── selected_theme       # Current theme

/usr/local/bin/vex-pkg   # Main executable
```

---

## Customization

### Add Your Own Packages

```bash
sudo nano /usr/share/vex/packages-lists/11-custom.txt
# Add your packages (one per line)
sudo vex-pkg install custom
```

### Add GNOME Extensions

```bash
sudo nano /usr/share/vex/config/gnome/extensions.txt
# Format: uuid|name|pk
# Example: vitals@corecoding.com|Vitals|1234
```

### Change Theme

```bash
sudo nano /usr/share/vex/config/selected_theme
# Options: red-white, cyberpunk, nord, dracula, 
#          tokyo-night, catppuccin, gruvbox, 
#          solarized, everforest, rose-pine
```

---

## Requirements

- Arch Linux (or any Arch-based distribution)
- Root privileges (sudo)
- Internet connection
- Minimum 2GB RAM (recommended)

---

## Contributing

Contributions are welcome! Feel free to:

- Star the repository
- Report issues
- Suggest new features
- Submit pull requests

---

## License

MIT License - Feel free to use, modify, and distribute.

---

## Creator

**Vexis** · [GitHub](https://github.com/VexisVX)

---

**Made with ❤️ for the Arch Linux community**
