#!/bin/bash
# ================================================================
# VEX-PKG Tools Installer - Ultimate Edition v4.0.3
# ================================================================
# Creator: Vexis (https://github.com/VexisVX)
# ================================================================
# Features:
#   - 15 Categories with beautiful tables
#   - Pentest-Pro with 11 Subcategories
#   - Theme Gallery (10 themes)
#   - Fun Tools (cowsay, figlet, cmatrix...)
#   - AUR support via yay
#   - Auto-completion
# ================================================================
# SECURITY: This script installs system-wide packages. Always review
# scripts before running them with root privileges.
# Recommended usage: curl -L -o install.sh [URL] && less install.sh && sudo bash install.sh
# ================================================================

set -Eeuo pipefail

# ================================================================
# Colors
# ================================================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Initialize counters
declare -i ERROR_COUNT=0
declare -i WARNING_COUNT=0

log_info() { echo -e "${GREEN}[+]${NC} $1"; }
log_error() { echo -e "${RED}[!]${NC} $1" >&2; ERROR_COUNT+=1; }
log_warn() { echo -e "${YELLOW}[*]${NC} $1"; WARNING_COUNT+=1; }
log_success() { echo -e "${GREEN}[✔]${NC} $1"; }
log_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}►${NC} ${BOLD}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

print_logo() {
    echo -e "${RED}"
    echo '  -@@@@=%@@@*.             =@@@@=@@@@=.      .#@@@#+@@@@:'
    echo '   -@@@@=@@@@+           :*.-@@@@+%@@@+     :%@@@+%@@@*.'
    echo '   .+@@@@+@@@@-          *@%:.%@@@*#@@@#.  -@@@@=@@@@=.'
    echo '    .%@@@#+@@@%.        +@@@@:.%@@@#*@@@%.=@@@%+@@@@:.'
    echo '     .%@@@#*@@@#.     .=@@@@%@+.+@@@@+@@**@@@**@@@#..'
    echo '      :@@@@*%@@@+.    .@@@@=@@@*.-@@@@=+%@@@+%@@@+.'
    echo '      .=@@@@-@@@@-   .@@@@=@@@@*. :%@@@@@@%-@@@@:..'
    echo '        +@@@@=@@@@: .*@@@*%@@@#..  .#@@@@#*@@@%:'
    echo '        .*@@@%*@@@%.=@@@#+@@@@:.  ..@@@@@@+@@@@:'
    echo '         .@@@@*#@@@=@@@%+@@@@:    :@@@@@@@@=@@@@='
    echo '          .@@@@+%@+@@@@+@@@@=.  .=@@@%++%@@@+%@@@+.'
    echo '           -@@@@++#@@@-%@@@*..  *@@@#+@@+%@@@+#@@@%.'
    echo '           .+@@@%#@@@+%@@@#.  :%@@@+%@@@+.*@@@#*@@@%:'
    echo '             *@@@@@@#*@@@%:  :@@@@=%@@@=.  *@@@%=@@@@-.'
    echo '             .#@@@@@@+@@@:..+@@@%+@@@@:     =@@@@+@@@@+'
    echo '              :@@@@@@%=@-..*@@@**@@@%:.      -@@@@=#@@@#.'
    echo '               .******+...+***-+***=          .+***=+***+.'
    echo -e "${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}                    VEX-OS TOOLS v4.0${NC}"
    echo -e "${BOLD}${CYAN}              Creator: Vexis (github.com/VexisVX)${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ================================================================
# Theme Palettes (10 themes)
# ================================================================
declare -A THEMES

THEMES["red-white"]='
background="#1a1414"
foreground="#e8d5d5"
color0="#2a1a1a" color8="#4a2a2a"
color1="#c46a6a" color9="#d48a7a"
color2="#8a9a7a" color10="#9aaa8a"
color3="#d4b8a8" color11="#e4c8b8"
color4="#7a8aa8" color12="#8a9ab8"
color5="#b08a9a" color13="#c09aaa"
color6="#7a9a8a" color14="#8aaaaa"
color7="#d0c0b8" color15="#e8d8d0"
user_color="#c46a6a"
host_color="#d4b8a8"
path_color="#e8d5d5"
git_color="#8a9a7a"
arrow_color="#d4b8a8"
border_color="#6a4a4a"
'

THEMES["cyberpunk"]='
background="#0a0a1a"
foreground="#00ffff"
color0="#0a0a1a" color8="#1a1a3a"
color1="#ff00ff" color9="#ff44ff"
color2="#00ff00" color10="#44ff44"
color3="#ffff00" color11="#ffff44"
color4="#0088ff" color12="#44aaff"
color5="#ff00aa" color13="#ff44aa"
color6="#00ffff" color14="#44ffff"
color7="#cccccc" color15="#ffffff"
user_color="#ff00ff"
host_color="#00ffff"
path_color="#0088ff"
git_color="#00ff00"
arrow_color="#ffff00"
border_color="#1a1a3a"
'

THEMES["nord"]='
background="#2e3440"
foreground="#d8dee9"
color0="#3b4252" color8="#4c566a"
color1="#bf616a" color9="#d08770"
color2="#a3be8c" color10="#b48ead"
color3="#ebcb8b" color11="#88c0d0"
color4="#81a1c1" color12="#5e81ac"
color5="#b48ead" color13="#d08770"
color6="#88c0d0" color14="#8fbcbb"
color7="#e5e9f0" color15="#eceff4"
user_color="#88c0d0"
host_color="#81a1c1"
path_color="#d8dee9"
git_color="#a3be8c"
arrow_color="#ebcb8b"
border_color="#4c566a"
'

THEMES["dracula"]='
background="#282a36"
foreground="#f8f8f2"
color0="#21222c" color8="#44475a"
color1="#ff5555" color9="#ff5555"
color2="#50fa7b" color10="#50fa7b"
color3="#f1fa8c" color11="#f1fa8c"
color4="#bd93f9" color12="#bd93f9"
color5="#ff79c6" color13="#ff79c6"
color6="#8be9fd" color14="#8be9fd"
color7="#f8f8f2" color15="#ffffff"
user_color="#bd93f9"
host_color="#ff79c6"
path_color="#f8f8f2"
git_color="#50fa7b"
arrow_color="#f1fa8c"
border_color="#44475a"
'

THEMES["tokyo-night"]='
background="#1a1b26"
foreground="#c0caf5"
color0="#1a1b26" color8="#414868"
color1="#f7768e" color9="#f7768e"
color2="#9ece6a" color10="#9ece6a"
color3="#e0af68" color11="#e0af68"
color4="#7aa2f7" color12="#7aa2f7"
color5="#bb9af7" color13="#bb9af7"
color6="#7dcfff" color14="#7dcfff"
color7="#c0caf5" color15="#ffffff"
user_color="#7aa2f7"
host_color="#bb9af7"
path_color="#c0caf5"
git_color="#9ece6a"
arrow_color="#e0af68"
border_color="#414868"
'

THEMES["catppuccin"]='
background="#1e1e2e"
foreground="#cdd6f4"
color0="#1e1e2e" color8="#313244"
color1="#f38ba8" color9="#f38ba8"
color2="#a6e3a1" color10="#a6e3a1"
color3="#f9e2af" color11="#f9e2af"
color4="#89b4fa" color12="#89b4fa"
color5="#cba6f7" color13="#cba6f7"
color6="#94e2d5" color14="#94e2d5"
color7="#cdd6f4" color15="#ffffff"
user_color="#cba6f7"
host_color="#89b4fa"
path_color="#cdd6f4"
git_color="#a6e3a1"
arrow_color="#f9e2af"
border_color="#313244"
'

THEMES["gruvbox"]='
background="#282828"
foreground="#ebdbb2"
color0="#282828" color8="#928374"
color1="#cc241d" color9="#fb4934"
color2="#98971a" color10="#b8bb26"
color3="#d79921" color11="#fabd2f"
color4="#458588" color12="#83a598"
color5="#b16286" color13="#d3869b"
color6="#689d6a" color14="#8ec07c"
color7="#a89984" color15="#ebdbb2"
user_color="#fb4934"
host_color="#fabd2f"
path_color="#ebdbb2"
git_color="#b8bb26"
arrow_color="#83a598"
border_color="#928374"
'

THEMES["solarized"]='
background="#002b36"
foreground="#839496"
color0="#073642" color8="#002b36"
color1="#dc322f" color9="#cb4b16"
color2="#859900" color10="#586e75"
color3="#b58900" color11="#657b83"
color4="#268bd2" color12="#839496"
color5="#6c71c4" color13="#6c71c4"
color6="#2aa198" color14="#93a1a1"
color7="#93a1a1" color15="#fdf6e3"
user_color="#268bd2"
host_color="#b58900"
path_color="#839496"
git_color="#859900"
arrow_color="#dc322f"
border_color="#073642"
'

THEMES["everforest"]='
background="#2d353b"
foreground="#d3c6aa"
color0="#232a2e" color8="#343f44"
color1="#e67e80" color9="#e67e80"
color2="#a7c080" color10="#a7c080"
color3="#dbbc7f" color11="#dbbc7f"
color4="#7fbbb3" color12="#7fbbb3"
color5="#d699b6" color13="#d699b6"
color6="#83c092" color14="#83c092"
color7="#d3c6aa" color15="#d3c6aa"
user_color="#d699b6"
host_color="#7fbbb3"
path_color="#d3c6aa"
git_color="#a7c080"
arrow_color="#dbbc7f"
border_color="#343f44"
'

THEMES["rose-pine"]='
background="#191724"
foreground="#e0def4"
color0="#191724" color8="#26233a"
color1="#eb6f92" color9="#eb6f92"
color2="#31748f" color10="#31748f"
color3="#f6c177" color11="#f6c177"
color4="#9ccfd8" color12="#9ccfd8"
color5="#c4a7e7" color13="#c4a7e7"
color6="#ebbcba" color14="#ebbcba"
color7="#e0def4" color15="#e0def4"
user_color="#c4a7e7"
host_color="#9ccfd8"
path_color="#e0def4"
git_color="#31748f"
arrow_color="#f6c177"
border_color="#26233a"
'

# ================================================================
# Select Theme
# ================================================================
select_theme() {
    log_header "🎨 Select Your Theme"
    echo ""
    echo -e "${BOLD}Available Themes:${NC}"
    echo ""

    themes_list=(
        "red-white|❤️  Red & White|Default VEX theme"
        "cyberpunk|💜 Cyberpunk|   Neon futuristic"
        "nord|💙 Nord|        Cool and calm"
        "dracula|💜 Dracula|     Dark and vibrant"
        "tokyo-night|🌃 Tokyo Night| Neon city lights"
        "catppuccin|🤎 Catppuccin|  Warm and cozy"
        "gruvbox|🧡 Gruvbox|     Retro and warm"
        "solarized|💛 Solarized|   Easy on the eyes"
        "everforest|🌿 Everforest|  Nature inspired"
        "rose-pine|🌸 Rose Pine|   Soft and elegant"
    )

    i=1
    for theme in "${themes_list[@]}"; do
        IFS='|' read -r name icon desc <<< "$theme"
        printf "  ${GREEN}%2d)${NC} ${icon} ${BOLD}%-15s${NC} %s\n" "$i" "$name" "$desc"
        i=$((i + 1))
    done

    echo ""
    read -p "$(echo -e "${YELLOW}Select theme [1-10] (default: 1): ${NC}")" theme_choice

    if [[ -z "$theme_choice" ]]; then
        theme_choice=1
    fi

    case "$theme_choice" in
        1) SELECTED_THEME="red-white" ;;
        2) SELECTED_THEME="cyberpunk" ;;
        3) SELECTED_THEME="nord" ;;
        4) SELECTED_THEME="dracula" ;;
        5) SELECTED_THEME="tokyo-night" ;;
        6) SELECTED_THEME="catppuccin" ;;
        7) SELECTED_THEME="gruvbox" ;;
        8) SELECTED_THEME="solarized" ;;
        9) SELECTED_THEME="everforest" ;;
        10) SELECTED_THEME="rose-pine" ;;
        *) SELECTED_THEME="red-white" ;;
    esac

    log_success "Theme selected: $SELECTED_THEME"
}

# ================================================================
# Get theme colors (safe parser, no eval)
# ================================================================
get_theme_colors() {
    theme_name="$1"
    theme_data="${THEMES[$theme_name]}"

    local line key val
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        while [[ "$line" =~ ^[[:space:]]*([a-zA-Z_][a-zA-Z0-9_]*)=\"([^\"]*)\"[[:space:]]*(.*)$ ]]; do
            key="${BASH_REMATCH[1]}"
            val="${BASH_REMATCH[2]}"
            printf -v "$key" '%s' "$val"
            line="${BASH_REMATCH[3]}"
        done
    done <<< "$theme_data"
}

# ================================================================
# Apply theme to configs
# ================================================================
apply_theme_to_configs() {
    theme_name="$1"
    get_theme_colors "$theme_name"

    log_header "🎨 Applying theme: $theme_name"

    # Kitty
    sudo tee "$VEX_ROOT/config/kitty/kitty.conf" > /dev/null << EOF
# VEX-OS Kitty Terminal - Theme: $theme_name
background_opacity 0.88
dynamic_background_opacity yes
background_blur 8
window_padding_width  18
window_padding_height 16
window_border_width 2
window_border_color $border_color
active_window_border_color $user_color
inactive_window_border_color $color8
window_rounded_corners 14
cursor_shape            block
cursor_blink_interval   0
cursor_text_color       $background
cursor_color            $user_color
selection_foreground    $background
selection_background    $user_color
background $background
foreground $foreground
color0 $color0
color8 $color8
color1 $color1
color9 $color9
color2 $color2
color10 $color10
color3 $color3
color11 $color11
color4 $color4
color12 $color12
color5 $color5
color13 $color13
color6 $color6
color14 $color14
color7 $color7
color15 $color15
font_family      JetBrainsMono Nerd Font
font_size        12.5
adjust_line_height  2
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map ctrl+shift+f toggle_fullscreen
scrollback_lines 10000
renderer opengl
sync_to_monitor no
enable_audio_bell no
confirm_os_window_close 0
strip_trailing_spaces smart
shell_integration enabled
mouse_hide_wait 2.0
url_color $color3
url_style curly
open_url_modifiers ctrl+shift
EOF

    # Fish
    sudo tee "$VEX_ROOT/config/fish/config.fish" > /dev/null << EOF
# VEX-OS Fish Config - Theme: $theme_name
set -gx EDITOR nvim
set -gx BROWSER firefox
set -gx TERMINAL kitty
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias clean='sudo pacman -Scc'
set -g fish_greeting
function fish_prompt
    set -l color_user     $user_color
    set -l color_host     $host_color
    set -l color_path     $path_color
    set -l color_git      $git_color
    set -l color_arrow    $arrow_color
    set -l color_border   $border_color
    set -l user (whoami)
    set -l host (uname -n 2>/dev/null; or echo "vx")
    set -l pwd (prompt_pwd)
    set_color \$color_border
    echo -n "╭──"
    set_color \$color_user
    echo -n "\$user"
    set_color \$color_border
    echo -n "@"
    set_color \$color_host
    echo -n "\$host"
    set_color \$color_border
    echo -n " ── "
    set_color \$color_path
    echo -n "\$pwd"
    echo ""
    set_color \$color_border
    echo -n "╰──"
    set_color \$color_arrow
    echo -n "❯ "
    set_color normal
end
if command -v fastfetch &>/dev/null
    fastfetch
end
setxkbmap ir 2>/dev/null
EOF

    # Fastfetch
    sudo tee "$VEX_ROOT/config/fastfetch/config.jsonc" > /dev/null << EOF
{
  "logo": {
    "type": "file",
    "source": "/usr/share/vex/config/fastfetch/logo.txt",
    "padding": { "right": 4 },
    "color": { "1": "$user_color", "2": "$foreground" }
  },
  "display": {
    "separator": " ",
    "color": { "keys": "$arrow_color", "title": "$foreground", "values": "$foreground" }
  },
  "modules": [
    {"key": "╭───────────╮", "type": "custom", "color": "$border_color"},
    {"key": "│  user    │", "type": "title", "format": "{user-name}", "color": "$user_color"},
    {"key": "│ 󰇅 hname   │", "type": "title", "format": "{host-name}", "color": "$host_color"},
    {"key": "│ 󰅐 uptime  │", "type": "uptime", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│  kernel  │", "type": "kernel", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰘳 wm      │", "type": "wm", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰇄 desktop │", "type": "de", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│  term    │", "type": "terminal", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│  shell   │", "type": "shell", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰍛 cpu     │", "type": "cpu", "showPeCoreCount": true, "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰉉 disk    │", "type": "disk", "folders": "/", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰑭 memory  │", "type": "memory", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "├───────────┤", "type": "custom", "color": "$border_color"},
    {"key": "│ ● colors  │", "type": "colors", "symbol": "circle", "keyColor": "$arrow_color"},
    {"key": "╰───────────╯", "type": "custom", "color": "$border_color"}
  ]
}
EOF

    log_success "Theme $theme_name applied to all configs"
}

# ================================================================
# Select configs to install (optional)
# ================================================================
select_configs() {
    log_header "🎨 Select Configurations to Install"
    echo ""
    echo -e "${CYAN}Which configs do you want to install?${NC}"
    echo ""

    config_options=(
        "fastfetch" "Fastfetch system info tool" "on"
        "kitty" "Kitty terminal emulator" "on"
        "fish" "Fish shell with prompt" "on"
    )

    if command -v dialog &>/dev/null; then
        selected_configs=$(dialog --stdout --checklist "Select configs:" 15 60 5 "${config_options[@]}" 2>/dev/null)
    else
        selected_configs="fastfetch kitty fish"
        log_info "All configs selected by default (dialog not available)"
    fi

    if [[ -z "$selected_configs" ]]; then
        selected_configs="fastfetch kitty fish"
        log_info "All configs selected by default"
    else
        log_info "Selected: $selected_configs"
    fi
}

# ================================================================
# Install selected configs only
# ================================================================
install_selected_configs() {
    log_header "📦 Installing Selected Configs"

    for config in $selected_configs; do
        case "$config" in
            fastfetch)
                if command -v fastfetch &>/dev/null; then
                    mkdir -p "$REAL_HOME/.config/fastfetch"
                    cp -r "$CONFIGS_DIR/fastfetch/"* "$REAL_HOME/.config/fastfetch/" 2>/dev/null || true
                    chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/fastfetch"
                    log_success "✅ Fastfetch configured"
                else
                    log_warn "Fastfetch not installed, skipping"
                fi
                ;;
            kitty)
                if command -v kitty &>/dev/null; then
                    mkdir -p "$REAL_HOME/.config/kitty"
                    cp "$CONFIGS_DIR/kitty/kitty.conf" "$REAL_HOME/.config/kitty/" 2>/dev/null || true
                    chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/kitty"
                    log_success "✅ Kitty configured"
                else
                    log_warn "Kitty not installed, skipping"
                fi
                ;;
            fish)
                if command -v fish &>/dev/null; then
                    mkdir -p "$REAL_HOME/.config/fish"
                    cp "$CONFIGS_DIR/fish/config.fish" "$REAL_HOME/.config/fish/" 2>/dev/null || true
                    chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/fish"
                    if ! grep -q "$(which fish)" /etc/shells 2>/dev/null; then
                        echo "$(which fish)" >> /etc/shells
                    fi
                    log_success "✅ Fish configured"
                else
                    log_warn "Fish not installed, skipping"
                fi
                ;;
        esac
    done
}

# ================================================================
# Setup BlackArch repository (with proper signature enforcement)
# ================================================================
setup_blackarch() {
    log_header "📦 BlackArch Repository Setup"

    if grep -q "^\[blackarch\]" /etc/pacman.conf; then
        log_success "BlackArch already configured"
        return 0
    fi

    log_info "Checking BlackArch mirrors..."

    blackarch_mirrors=(
        "https://mirror.telepoint.bg/blackarch"
        "https://mirrors.fosshost.com/blackarch"
        "https://mirrors.tuna.tsinghua.edu.cn/blackarch"
    )

    for mirror in "${blackarch_mirrors[@]}"; do
        if curl -s -o /dev/null --connect-timeout 3 --max-time 5 --fail "${mirror}/blackarch/os/x86_64/blackarch.db" 2>/dev/null; then
            log_success "Found working mirror: $mirror"

            # Bootstrap: TrustAll is required to fetch the keyring package itself
            cat >> /etc/pacman.conf << EOF

[blackarch]
SigLevel = Optional TrustAll
Server = ${mirror}/\$repo/os/\$arch
EOF
            pacman -Sy --noconfirm 2>/dev/null || true
            if ! pacman -S --needed --noconfirm blackarch-keyring 2>/dev/null; then
                sed -i '/^\[blackarch\]/,/^$/d' /etc/pacman.conf
                log_warn "BlackArch keyring failed, removing"
                return 1
            fi

            # Now that the keyring is present, enforce signature verification
            sed -i '/^\[blackarch\]/,/^$/ s/^SigLevel = Optional TrustAll$/SigLevel = Required DatabaseOptional/' /etc/pacman.conf
            pacman -Sy --noconfirm 2>/dev/null || true
            log_success "BlackArch repository configured (signature verification enforced)"
            return 0
        fi
    done

    log_warn "No working BlackArch mirrors found"
    return 1
}

# ================================================================
# Setup Reflector
# ================================================================
setup_reflector() {
    log_header "📡 Setting up Reflector"

    if ! command -v reflector &>/dev/null; then
        log_info "Installing reflector..."
        pacman -S --needed --noconfirm reflector 2>/dev/null || {
            log_warn "Reflector installation failed"
            return 1
        }
    fi

    log_info "Finding fastest mirrors..."
    reflector --verbose --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist 2>/dev/null || {
        log_warn "Reflector failed, using default mirrors"
        return 1
    }

    pacman -Syy --noconfirm 2>/dev/null || true
    log_success "Mirrors updated with reflector"
}

# ================================================================
# Check system and root
# ================================================================
if ! command -v pacman &>/dev/null; then
    log_error "This script only works on Arch-based distributions"
    exit 1
fi

# Smart root check: re-exec with sudo if needed, but preserve environment
if [[ $EUID -ne 0 ]]; then
    if ! command -v sudo &>/dev/null; then
        echo -e "${RED}[!]${NC} This installer needs root privileges and 'sudo' is not available. Re-run as root instead." >&2
        exit 1
    fi
    log_warn "Root privileges required — re-running with sudo..."
    exec sudo -E bash "$0" "$@"
fi

print_logo

log_header "🚀 Installing VEX Tools v4.0"
log_info "Distribution: $(grep "^NAME=" /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Unknown")"
log_info "Kernel: $(uname -r)"

# ================================================================
# Check internet
# ================================================================
if ! ping -c 1 -W 3 8.8.8.8 &>/dev/null; then
    log_warn "Internet: Not connected (some features may fail)"
else
    log_success "Internet: Connected"
fi

# ================================================================
# Setup Reflector (optional)
# ================================================================
echo ""
read -p "$(echo -e "${YELLOW}Setup Reflector for fastest mirrors? (y/N): ${NC}")" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    setup_reflector
fi

# ================================================================
# Setup BlackArch (optional)
# ================================================================
echo ""
read -p "$(echo -e "${YELLOW}Setup BlackArch repository for pentest tools? (y/N): ${NC}")" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    setup_blackarch
fi

# ================================================================
# Create VEX structure
# ================================================================
log_header "📁 Creating VEX Structure"

VEX_ROOT="/usr/share/vex"
REAL_USER="${SUDO_USER:-$(whoami)}"
REAL_HOME=$(eval echo ~"$REAL_USER")
CONFIGS_DIR="$VEX_ROOT/config"
PKG_LISTS="$VEX_ROOT/packages-lists"

mkdir -p "$VEX_ROOT"/{lib/core,lib/modules,config,packages-lists}
log_success "VEX directories created"

# ================================================================
# Create core files (config.sh, logging.sh, utils.sh, package.sh)
# ================================================================
log_header "📚 Creating Core Files"

# config.sh
sudo tee "$VEX_ROOT/lib/core/config.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Core Config
readonly VERSION="4.0.0"
readonly VEX_ROOT="/usr/share/vex"
readonly LIB_DIR="${VEX_ROOT}/lib"
readonly CORE_DIR="${LIB_DIR}/core"
readonly MODULES_DIR="${LIB_DIR}/modules"
readonly CONFIGS_DIR="${VEX_ROOT}/config"
readonly PKG_LISTS="${VEX_ROOT}/packages-lists"
readonly LOG_DIR="/var/log/vex"
readonly REAL_USER="${SUDO_USER:-$(whoami)}"
readonly REAL_HOME=$(eval echo ~"$REAL_USER")
readonly LOG_FILE="${LOG_DIR}/vex-$(date +%Y%m%d-%H%M%S).log"

export ERROR_COUNT=${ERROR_COUNT:-0}
export WARNING_COUNT=${WARNING_COUNT:-0}
export INSTALLED_COUNT=${INSTALLED_COUNT:-0}
export FAILED_COUNT=${FAILED_COUNT:-0}
export SKIPPED_COUNT=${SKIPPED_COUNT:-0}
declare -a FAILED_PACKAGES=() SKIPPED_PACKAGES=()
EOF

# logging.sh
sudo tee "$VEX_ROOT/lib/core/logging.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Logging Functions
export RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' BLUE='\033[0;34m' CYAN='\033[0;36m' BOLD='\033[1m' NC='\033[0m'
log_info() { echo -e "${GREEN}[+]${NC} $1" | sudo tee -a "${LOG_FILE:-/dev/null}"; }
log_error() { echo -e "${RED}[!]${NC} $1" | sudo tee -a "${LOG_FILE:-/dev/null}" >&2; ERROR_COUNT=$(( ${ERROR_COUNT:-0} + 1 )); }
log_warn() { echo -e "${YELLOW}[*]${NC} $1" | sudo tee -a "${LOG_FILE:-/dev/null}"; WARNING_COUNT=$(( ${WARNING_COUNT:-0} + 1 )); }
log_success() { echo -e "${GREEN}[✔]${NC} $1" | sudo tee -a "${LOG_FILE:-/dev/null}"; }
log_header() { echo "" | sudo tee -a "${LOG_FILE:-/dev/null}"; echo -e "${BLUE}═══════════════════════════════════════${NC}" | sudo tee -a "${LOG_FILE:-/dev/null}"; echo -e "${BLUE}►${NC} ${BOLD}$1${NC}" | sudo tee -a "${LOG_FILE:-/dev/null}"; echo -e "${BLUE}═══════════════════════════════════════${NC}" | sudo tee -a "${LOG_FILE:-/dev/null}"; }
EOF

# utils.sh
sudo tee "$VEX_ROOT/lib/core/utils.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Utility Functions
check_internet() { ping -c 1 -W 3 8.8.8.8 &>/dev/null || ping -c 1 -W 3 1.1.1.1 &>/dev/null; }
command_exists() { command -v "$1" &>/dev/null; }
is_installed() { pacman -Q "$1" &>/dev/null || sudo -u "$REAL_USER" yay -Q "$1" 2>/dev/null; }
get_pkg_count() { local f="$1"; [[ -f "$f" ]] && grep -v '^#' "$f" 2>/dev/null | grep -v '^$' | wc -l || echo "0"; }
ensure_dirs() { mkdir -p "$PKG_LISTS" "$CONFIGS_DIR" "$LOG_DIR" 2>/dev/null || true; }
EOF

# package.sh (single source of truth for PENTEST_SUBS, CATEGORY_ALIASES, PKG_INFO)
sudo tee "$VEX_ROOT/lib/core/package.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Package Core

declare -A PENTEST_SUBS

PENTEST_SUBS["Recon"]="
amass subfinder theharvester recon-ng spiderfoot sherlock dnsrecon enum4linux fierce dnsenum nbtscan onesixtyone shodan censys httpx naabu dnsx puredns chaos github-subdomains shuffledns findomain knock sublist3r osmedeus anubis dnsprobe massdns dnsvalidator cloudenum awscli gcloud azure-cli cloud_enum bucket_finder s3scanner lazys3 dnsgen altdns nmap masscan rustscan zdns ldapdomaindump dnsdumpster photon waybackurls gau gospider hakrawler cariddi filter-resolved"
PENTEST_SUBS["Web"]="
sqlmap nosqlmap sqlninja bbqsql jsql-injection sqliv sqlsus ffuf gobuster wfuzz dirsearch dirb nikto whatweb wpscan joomscan droopescan cmsmap commix dalfox xsstrike xsser xss-payload arjun parameth waybackurls gau nuclei subjack feroxbuster corsy cdncheck hakrawler cariddi filter-resolved gowitness aquatone eyewitness httprobe smuggler kiterunner graphql-cop graphql-voyager jwt-tool jwt-cracker jwt-hack ssti-payload ssti-scanner lfi-finder rfi-finder open-redirect ssrf-finder crlf-injector h2c-smuggler cache-poison cache-vuln xxe-injector xxe-scanner deserialization-scanner restler-fuzzer restler wapiti burpsuite"
PENTEST_SUBS["Exploit"]="
metasploit exploitdb evil-winrm bloodhound bloodhound-python netexec shellter routersploit aclpwn msfvenom searchsploit setoolkit impacket responder smbclient rpcclient pwnkit linux-exploit-suggester windows-exploit-suggester local-exploit exploit-db msfpc mimi mimikatz keimpx pth-toolkit psexec wmiexec atexec dcomexec smbexec goldeneye slowloris hping3 fuxploider lse beef cobaltstrike empire merlin crossC2 sliver covenant shad0w govenom venom"
PENTEST_SUBS["Network"]="
wireshark-qt tcpdump ettercap mitm6 dsniff macchanger arp-scan netdiscover nping ngrep tshark tcpflow mitmproxy hping3 socat zmap scapy nemesis packETH traceroute mtr bmon iptraf-ng vnstat iftop nethogs iperf3 mausezahn tcpreplay tcprewrite netsniff-ng fragrouter hamster-sidejack killall dhcping dnschef"
PENTEST_SUBS["Credential"]="
hashcat john hydra crunch cewl hashid hashcat-utils kwprocessor maskprocessor rsmangler mimikatz laZagne hash-identifier rubeus kerbrute bloodhound-python certipy adidnsdump pywerview impacket evil-winrm netexec pth-toolkit responder smbclient enum4linux-ng secretsdump lsassy nanodump mimi katz pass-the-hash"
PENTEST_SUBS["Social"]="
bettercap gophish hiddeneye wifiphisher blackeye fluxion seeker social-analyzer ghost-phisher evilginx2 king-phisher modlishka credential-phisher beef socialfish zphisher shellphish advphishing fastphish evilurl phishery"
PENTEST_SUBS["C2"]="
proxychains-ng tor openvpn wireguard-tools chisel ligolo-ng sliver bore stunnel autossh ncat frp ngrok pivotnacci socks5 termite venom merlin cobaltstrike empire covenant crossC2 shad0w govenom"
PENTEST_SUBS["Wireless"]="
aircrack-ng airgeddon wifite mdk3 hcxtools hcxdumptool reaver kismet bully pixiewps hostapd dnsmasq eaphammer mdk4 bettercap wifi-honey fluxion wifipumpkin airmon-ng airodump-ng kismet wifite2 wpa-supplicant hostapd-wpe"
PENTEST_SUBS["Privesc"]="
linux-exploit-suggester watson pspy beroot linenum certipy peass gtfo suid3num lse linuxprivchecker unix-privesc-check windows-privesc-check powerup beRoot linpeas winpeas pwnkit polkit-exploit SUID3NUM winlogbeat deepce unix-privesc-check"
PENTEST_SUBS["OSINT"]="
maigret holehe phoneinfoga whatbreach trape tinfoleak photon metagoofil ghunt osintgram perl-image-exiftool theharvester recon-ng sherlock twint instagram-scraper facebook-osint linkedin-analyzer github-osint email-osint username-search geolocation-tools shodan-cli censys-cli virustotal-cli recon-ng spiderfoot photon metagoofil ghunt osintgram"
PENTEST_SUBS["Serialization"]="
phpggc ruby-serialize ysoserial burp zap ffuf wfuzz hash-analyzer crypto-tools binary-exploitation jd-gui fernflower cfr procyon luyten"

declare -A CATEGORY_ALIASES
CATEGORY_ALIASES["core"]="00-core"
CATEGORY_ALIASES["base"]="01-base"
CATEGORY_ALIASES["desktop"]="02-desktop"
CATEGORY_ALIASES["dev"]="03-dev"
CATEGORY_ALIASES["development"]="03-dev"
CATEGORY_ALIASES["pentest-light"]="04-pentest-light"
CATEGORY_ALIASES["pentestlight"]="04-pentest-light"
CATEGORY_ALIASES["pentest-pro"]="05-pentest-pro"
CATEGORY_ALIASES["pentestpro"]="05-pentest-pro"
CATEGORY_ALIASES["gaming"]="06-gaming"
CATEGORY_ALIASES["media"]="07-media"
CATEGORY_ALIASES["network"]="08-network"
CATEGORY_ALIASES["net"]="08-network"
CATEGORY_ALIASES["privacy"]="09-privacy"
CATEGORY_ALIASES["aur"]="10-aur"
CATEGORY_ALIASES["custom"]="11-custom"
CATEGORY_ALIASES["configs"]="12-configs"
CATEGORY_ALIASES["gpu"]="13-gpu"
CATEGORY_ALIASES["downloaders"]="14-downloaders"
CATEGORY_ALIASES["fun"]="15-fun"
CATEGORY_ALIASES["fun-tools"]="15-fun"

declare -A PKG_INFO
PKG_INFO["kitty"]="Modern, feature-rich GPU-based terminal emulator|https://sw.kovidgoyal.net/kitty/|12.5 MB"
PKG_INFO["fish"]="Smart and user-friendly command line shell|https://fishshell.com/|8.2 MB"
PKG_INFO["fastfetch"]="Fast system information tool like neofetch|https://github.com/fastfetch-cli/fastfetch|2.1 MB"
PKG_INFO["proxychains-ng"]="Proxy chaining tool|https://github.com/haad/proxychains|2.5 MB"

resolve_category() {
    case "$1" in
        "Core"|"core") echo "00-core" ;;
        "Base"|"base") echo "01-base" ;;
        "Desktop"|"desktop") echo "02-desktop" ;;
        "Development"|"development") echo "03-dev" ;;
        "Pentest-Light"|"pentest-light"|"Pentest Light") echo "04-pentest-light" ;;
        "Pentest-Pro"|"pentest-pro"|"Pentest Pro") echo "05-pentest-pro" ;;
        "Gaming"|"gaming") echo "06-gaming" ;;
        "Media"|"media") echo "07-media" ;;
        "Network"|"network") echo "08-network" ;;
        "Privacy"|"privacy") echo "09-privacy" ;;
        "AUR"|"aur") echo "10-aur" ;;
        "Custom"|"custom") echo "11-custom" ;;
        "Configs"|"configs") echo "12-configs" ;;
        "GPU"|"gpu") echo "13-gpu" ;;
        "Downloaders"|"downloaders") echo "14-downloaders" ;;
        "Fun-Tools"|"fun-tools"|"Fun"|"fun"|"Fun Tools") echo "15-fun" ;;
        *) echo "$1" ;;
    esac
}

get_friendly_name() {
    case "$1" in
        "00-core") echo "Core" ;;
        "01-base") echo "Base" ;;
        "02-desktop") echo "Desktop" ;;
        "03-dev") echo "Development" ;;
        "04-pentest-light") echo "Pentest-Light" ;;
        "05-pentest-pro") echo "Pentest-Pro" ;;
        "06-gaming") echo "Gaming" ;;
        "07-media") echo "Media" ;;
        "08-network") echo "Network" ;;
        "09-privacy") echo "Privacy" ;;
        "10-aur") echo "AUR" ;;
        "11-custom") echo "Custom" ;;
        "12-configs") echo "Configs" ;;
        "13-gpu") echo "GPU" ;;
        "14-downloaders") echo "Downloaders" ;;
        "15-fun") echo "Fun-Tools" ;;
        *) echo "$1" ;;
    esac
}

draw_table_border() {
    local left="$1" mid="$2" right="$3" color="$4"
    shift 4
    local out="${color}${left}"
    local first=1
    for w in "$@"; do
        [[ $first -eq 0 ]] && out+="${mid}"
        out+=$(printf '═%.0s' $(seq 1 $((w + 2))))
        first=0
    done
    out+="${right}${NC}"
    echo -e "$out"
}

list_categories() {
    log_header "📦 Available Categories"
    echo ""

    local border="${VEX_COLOR_HEADER:-$CYAN}"
    local head="${VEX_COLOR_PRIMARY:-$CYAN}"
    local name_c="${VEX_COLOR_ACCENT:-$GREEN}"
    local count_c="${VEX_COLOR_SECONDARY:-$YELLOW}"

    local name_w=16
    local count_w=9
    local desc_w=40
    local has_pentest_pro=0

    draw_table_border "╔" "╦" "╗" "$border" "$name_w" "$count_w" "$desc_w"
    echo -e "${border}║${NC} ${head}$(printf '%-*s' "$name_w" "Category")${NC} ${border}║${NC} ${head}$(printf '%-*s' "$count_w" "Packages")${NC} ${border}║${NC} ${head}$(printf '%-*s' "$desc_w" "Description")${NC} ${border}║${NC}"
    draw_table_border "╠" "╬" "╣" "$border" "$name_w" "$count_w" "$desc_w"

    for f in "$PKG_LISTS"/*.txt; do
        n=$(basename "$f" .txt)
        
        # skip same files
        if [[ "$n" == "09-aur" ]] || [[ "$n" == "10-custom" ]] || [[ "$n" == "11-configs" ]] || [[ "$n" == "12-gpu" ]]; then
            continue
        fi
        
        friendly=$(get_friendly_name "$n")
        
        # calculate all packages
        local c=0
        local desc=""
        
        case "$friendly" in
            "Pentest-Pro")
                # Calculate all packages
                for sub in "${!PENTEST_SUBS[@]}"; do
                    local sub_count=$(echo "${PENTEST_SUBS[$sub]}" | wc -w)
                    c=$((c + sub_count))
                done
                desc="PENTEST PRO - Advanced Security Toolkit (500+ Tools)"
                has_pentest_pro=1
                ;;
            "Custom")
                # empty config 
                local pkg_count=$(grep -v '^#' "$f" 2>/dev/null | grep -v '^$' | wc -l)
                if [[ $pkg_count -eq 0 ]]; then
                    c="-"
                    desc="Add your own packages (edit this file)"
                else
                    c=$pkg_count
                    desc="User-defined packages ($c packages)"
                fi
                ;;
            "Configs")
                c="-"
                desc="System configurations (apply with: vex-pkg apply configs)"
                ;;
            *)
                c=$(get_pkg_count "$f")
                desc=$(head -1 "$f" 2>/dev/null | sed 's/^# //' || echo "No description")
                ;;
        esac

        if [[ ${#desc} -gt $desc_w ]]; then
            desc="${desc:0:$((desc_w - 1))}…"
        fi

        echo -e "${border}║${NC} ${name_c}$(printf '%-*s' "$name_w" "$friendly")${NC} ${border}║${NC} ${count_c}$(printf '%-*s' "$count_w" "$c")${NC} ${border}║${NC} $(printf '%-*s' "$desc_w" "$desc") ${border}║${NC}"
    done

    draw_table_border "╚" "╩" "╝" "$border" "$name_w" "$count_w" "$desc_w"

    if [[ $has_pentest_pro -eq 1 ]]; then
        echo ""
        echo -e "  ${count_c}ℹ${NC}  Pentest-Pro has subcategories — use: ${name_c}vex-pkg show Pentest-Pro <sub>${NC}"
    fi
}

show_category() {
    c="$1"
    sub="${2:-}"

    if [[ "$c" == "Pentest-Pro" ]] || [[ "$c" == "pentest-pro" ]] || [[ "$c" == "05-pentest-pro" ]]; then
        if [[ -n "$sub" ]] && [[ -n "${PENTEST_SUBS[$sub]:-}" ]]; then
            log_header "📋 Pentest-Pro - ${sub}"
            for tool in ${PENTEST_SUBS[$sub]}; do
                if is_installed "$tool"; then
                    echo -e "  ${GREEN}●${NC} $tool ${GREEN}(installed)${NC}"
                else
                    echo -e "  ${YELLOW}○${NC} $tool"
                fi
            done
            echo ""
            count=$(echo "${PENTEST_SUBS[$sub]}" | wc -w)
            log_info "Total tools: $count"
        else
            log_header "📋 Pentest-Pro Subcategories"
            echo ""
            echo -e "${BOLD}Available subcategories:${NC}"
            for key in "${!PENTEST_SUBS[@]}"; do
                count=$(echo "${PENTEST_SUBS[$key]}" | wc -w)
                printf "  ${GREEN}●${NC} %-15s ${CYAN}%3d${NC} tools\n" "$key" "$count"
            done
            echo ""
            echo -e "${YELLOW}Usage: vex-pkg show Pentest-Pro <subcategory>${NC}"
            echo -e "${YELLOW}Example: vex-pkg show Pentest-Pro Web${NC}"
        fi
        return
    fi

    c=$(resolve_category "$c")
    f="$PKG_LISTS/${c}.txt"
    [[ ! -f "$f" ]] && { log_error "Category not found"; return 1; }

    friendly=$(get_friendly_name "$c")
    log_header "📋 ${friendly}"

    local name_c="${VEX_COLOR_ACCENT:-$GREEN}"
    local dim_c="${VEX_COLOR_SECONDARY:-$YELLOW}"

    while IFS= read -r l; do
        [[ -z "$l" || "$l" =~ ^# ]] && continue
        if is_installed "$l"; then
            echo -e "  ${name_c}●${NC} $l ${name_c}(installed)${NC}"
        else
            echo -e "  ${dim_c}○${NC} $l"
        fi
    done < "$f"
}

show_pkg_info() {
    pkg="$1"
    if [[ -z "$pkg" ]]; then
        log_error "Usage: vex-pkg info <package>"
        return 1
    fi
    log_header "📦 Package Info: $pkg"

    if is_installed "$pkg"; then
        status="${GREEN}Installed${NC}"
    else
        status="${YELLOW}Not installed${NC}"
    fi

    info="${PKG_INFO[$pkg]:-}"
    if [[ -n "$info" ]]; then
        IFS='|' read -r desc homepage size <<< "$info"
        echo -e "  ${CYAN}Description:${NC} $desc"
        echo -e "  ${CYAN}Homepage:${NC}   $homepage"
        echo -e "  ${CYAN}Size:${NC}        $size"
    fi

    category=""
    for f in "$PKG_LISTS"/*.txt; do
        if grep -q "^$pkg\$" "$f" 2>/dev/null; then
            category=$(basename "$f" .txt)
            break
        fi
    done
    if [[ -n "$category" ]]; then
        echo -e "  ${CYAN}Category:${NC}    ${category}"
    fi
    echo -e "  ${CYAN}Status:${NC}     $status"
}

search_packages() {
    query="$1"
    if [[ -z "$query" ]]; then
        log_error "Usage: vex-pkg search <query>"
        return 1
    fi
    log_header "🔍 Search Results for: $query"
    found=0
    for f in "$PKG_LISTS"/*.txt; do
        category=$(basename "$f" .txt)
        while IFS= read -r line; do
            [[ -z "$line" || "$line" =~ ^# ]] && continue
            if [[ "$line" == *"$query"* ]]; then
                printf "  ${CYAN}●${NC} %-25s ${YELLOW}[%s]${NC}\n" "$line" "$category"
                found=$((found + 1))
            fi
        done < "$f"
    done
    if [[ $found -eq 0 ]]; then
        echo -e "  ${YELLOW}No packages found matching '$query'${NC}"
    else
        echo ""
        log_info "Found $found package(s)"
    fi
}

install_specific_packages() {
    if [[ $# -eq 0 ]]; then
        log_error "Usage: vex-pkg install <package1> <package2> ..."
        return 1
    fi

    packages=("$@")
    log_header "📦 Installing Specific Packages"
    installed=0 failed=0

    for pkg in "${packages[@]}"; do
        log_info "Installing: $pkg"
        if is_installed "$pkg"; then
            log_info "⏭️ $pkg already installed"
            continue
        fi

        if pacman -S --needed --noconfirm "$pkg" 2>/dev/null; then
            log_success "✅ $pkg (official)"
            installed=$((installed + 1))
        elif command_exists yay && sudo -u "$REAL_USER" yay -S --needed --noconfirm "$pkg" 2>/dev/null; then
            log_success "✅ $pkg (AUR)"
            installed=$((installed + 1))
        else
            log_error "❌ Failed: $pkg"
            failed=$((failed + 1))
        fi
    done
    echo ""
    log_info "Installed: $installed | Failed: $failed"
}

install_category() {
    c="$1"

    if [[ -n "${CATEGORY_ALIASES[$c]:-}" ]]; then
        c="${CATEGORY_ALIASES[$c]}"
    fi

    c=$(resolve_category "$c")

    f="$PKG_LISTS/${c}.txt"
    [[ ! -f "$f" ]] && { log_error "Category not found: $c"; return 1; }

    friendly=$(get_friendly_name "$c")
    log_header "📦 Installing: ${friendly}"
    total=0 installed=0 failed=0 skipped=0
    while IFS= read -r l; do
        [[ -z "$l" || "$l" =~ ^# ]] && continue
        total=$((total + 1))
        if is_installed "$l"; then
            log_info "⏭️ $l already installed"
            skipped=$((skipped + 1))
            continue
        fi
        if pacman -S --needed --noconfirm "$l" 2>/dev/null; then
            log_success "✅ $l (official)"
            installed=$((installed + 1))
        elif command_exists yay && sudo -u "$REAL_USER" yay -S --needed --noconfirm "$l" 2>/dev/null; then
            log_success "✅ $l (AUR)"
            installed=$((installed + 1))
        else
            log_error "❌ Failed: $l"
            failed=$((failed + 1))
        fi
    done < "$f"
    echo ""
    log_info "Summary: $installed installed, $skipped skipped, $failed failed"
}

install_all_categories() {
    log_header "🚀 Installing All Categories"
    for f in "$PKG_LISTS"/*.txt; do
        n=$(basename "$f" .txt)
        [[ "$n" == "11-custom" ]] && continue
        [[ "$n" == "12-configs" ]] && continue
        install_category "$n"
        echo ""
    done
}

apply_module() {
    m="$1"
    f="$MODULES_DIR/${m}.sh"
    [[ ! -f "$f" ]] && { log_error "Module not found: $m"; return 1; }
    source "$f"
    case "$m" in
        gnome) install_gnome_complete ;;
        configs) install_configs ;;
        gpu) install_gpu_drivers ;;
        services) enable_services ;;
        aur) install_yay ;;
        mirrors) configure_mirrors ;;
        fun) install_fun_tools ;;
        *) log_error "Unknown module: $m"; return 1 ;;
    esac
}

cmd_doctor() {
    log_header "🩺 Health Check"
    check_internet && log_success "Internet: OK" || log_error "Internet: No"
    pacman -Q &>/dev/null && log_success "Pacman: OK" || log_error "Pacman: No"
    command_exists yay && log_success "Yay: Installed" || log_warn "Yay: Not installed"
    log_info "Packages: $(pacman -Q 2>/dev/null | wc -l)"
}

cmd_cleanup() {
    log_header "🧹 Cleaning"
    pacman -Sc --noconfirm 2>/dev/null || true
    log_success "Cleanup complete"
}
EOF

log_success "Core files created"

# ================================================================
# Create modules (aur.sh, configs.sh, gnome.sh, gpu.sh, mirrors.sh, services.sh, fun.sh)
# ================================================================
log_header "📚 Creating Modules"

# aur.sh
sudo tee "$VEX_ROOT/lib/modules/aur.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX AUR Module
install_yay() {
    log_header "🔧 Installing Yay"
    if command -v yay &>/dev/null; then
        log_success "Yay already installed"
        return 0
    fi
    log_info "Installing yay..."
    pacman -S --needed --noconfirm git base-devel 2>/dev/null || {
        log_error "Failed to install dependencies"
        return 1
    }
    sudo -u "$REAL_USER" bash -c "cd /tmp && rm -rf yay && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm" 2>/dev/null || {
        log_error "Yay installation failed"
        return 1
    }
    log_success "Yay installed"
}
EOF

# configs.sh
sudo tee "$VEX_ROOT/lib/modules/configs.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Configs Module
install_configs() {
    log_header "🎨 Installing VEX Configurations"
    installed=0 failed=0

    if command -v fastfetch &>/dev/null; then
        mkdir -p "$REAL_HOME/.config/fastfetch"
        if [[ -d "$CONFIGS_DIR/fastfetch" ]]; then
            cp -r "$CONFIGS_DIR/fastfetch/"* "$REAL_HOME/.config/fastfetch/" 2>/dev/null && {
                chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/fastfetch"
                log_success "✅ Fastfetch configured"
                installed=$((installed + 1))
            } || { log_warn "Fastfetch config failed"; failed=$((failed + 1)); }
        fi
    fi

    if command -v kitty &>/dev/null; then
        mkdir -p "$REAL_HOME/.config/kitty"
        if [[ -f "$CONFIGS_DIR/kitty/kitty.conf" ]]; then
            cp "$CONFIGS_DIR/kitty/kitty.conf" "$REAL_HOME/.config/kitty/" 2>/dev/null && {
                chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/kitty"
                log_success "✅ Kitty configured"
                installed=$((installed + 1))
            } || { log_warn "Kitty config failed"; failed=$((failed + 1)); }
        fi
    fi

    if command -v fish &>/dev/null; then
        mkdir -p "$REAL_HOME/.config/fish"
        if [[ -f "$CONFIGS_DIR/fish/config.fish" ]]; then
            cp "$CONFIGS_DIR/fish/config.fish" "$REAL_HOME/.config/fish/" 2>/dev/null && {
                chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/fish"
                log_success "✅ Fish configured"
                installed=$((installed + 1))
            } || { log_warn "Fish config failed"; failed=$((failed + 1)); }
        fi
        if ! grep -q "$(which fish)" /etc/shells 2>/dev/null; then
            echo "$(which fish)" >> /etc/shells
        fi
    fi

    log_info "Configs: $installed installed, $failed failed"
}
EOF

# gnome.sh
sudo tee "$VEX_ROOT/lib/modules/gnome.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX GNOME Module - FULL VALIDATED

install_gnome_complete() {
    log_header "🖥️ GNOME Setup"
    
    # ============================================
    # DETECT GNOME
    # ============================================
    if ! command -v gnome-shell &>/dev/null; then
        log_warn "GNOME not detected, skipping"
        return 0
    fi
    

    local gnome_version="unknown"
    if command -v gnome-shell &>/dev/null; then
        gnome_version=$(gnome-shell --version 2>/dev/null | grep -oP '\d+\.\d+' | head -1 || echo "unknown")
    fi
    log_info "GNOME version: $gnome_version"
    log_success "GNOME detected"

    # ============================================
    # INSTALL DEPENDENCIES
    # ============================================
    log_info "Installing dependencies..."
    
    # Fix pacman lock
    local DB_LOCK="/var/lib/pacman/db.lck"
    [[ -f "$DB_LOCK" ]] && rm -f "$DB_LOCK"
    
    pacman -Syy --noconfirm 2>/dev/null || true
    pacman -S --needed --noconfirm python-pip python-pipx gnome-shell gnome-shell-extensions curl wget 2>/dev/null || {
        log_warn "pacman failed, retrying..."
        [[ -f "$DB_LOCK" ]] && rm -f "$DB_LOCK"
        pacman -S --needed --noconfirm python-pip python-pipx gnome-shell gnome-shell-extensions curl wget 2>/dev/null || true
    }

    # ============================================
    # INSTALL GEXT (gnome-extensions-cli)
    # ============================================
    log_info "Installing gext..."
    
    sudo -u "$REAL_USER" bash <<'INNER_EOF'
        if ! command -v pipx &> /dev/null; then
            python -m pip install --user pipx 2>&1
            python -m pipx ensurepath 2>&1
        fi
        pipx install gnome-extensions-cli --system-site-packages 2>&1 || {
            pip install --user --break-system-packages gnome-extensions-cli 2>&1
        }
INNER_EOF

    export PATH="$PATH:$REAL_HOME/.local/bin"
    
    local GEXT=""
    if [[ -f "$REAL_HOME/.local/bin/gext" ]]; then
        GEXT="$REAL_HOME/.local/bin/gext"
    elif command -v gext &>/dev/null; then
        GEXT="gext"
    else
        log_warn "gext not found - extensions will be skipped"
        log_info "Try manually: pip install --user --break-system-packages gnome-extensions-cli"
        return 1
    fi
    
    log_success "gext installed: $GEXT"

    # ============================================
    # EXTENSIONS LIST
    # ============================================
    local EXTENSIONS=(
        "blur-my-shell@aunetx"
        "burn-my-windows@schneegans.github.com"
        "desktop-cube@schneegans.github.com"
        "compiz-windows-effect@hermes83.github.com"
        "panel-corners@aunetx"
        "dash-to-dock@micxgx.gmail.com"
        "dash-to-panel@jderose9.github.com"
        "arcmenu@arcmenu.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "space-bar@luchrioh"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "clipboard-indicator@tudmotu.com"
        "ddterm@amezin.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
    )

    # ============================================
    # PK NUMBERS FOR FALLBACK
    # ============================================
    declare -A PK_MAP=(
        ["blur-my-shell@aunetx"]="3193"
        ["dash-to-dock@micxgx.gmail.com"]="307"
        ["arcmenu@arcmenu.com"]="3628"
        ["burn-my-windows@schneegans.github.com"]="4679"
        ["desktop-cube@schneegans.github.com"]="4648"
        ["compiz-windows-effect@hermes83.github.com"]="3210"
        ["user-theme@gnome-shell-extensions.gcampax.github.com"]="19"
        ["gsconnect@andyholmes.github.io"]="1319"
        ["ddterm@amezin.github.com"]="3780"
        ["panel-corners@aunetx"]="58032"
        ["space-bar@luchrioh"]="0"
        ["workspace-indicator@gnome-shell-extensions.gcampax.github.com"]="0"
        ["system-monitor@gnome-shell-extensions.gcampax.github.com"]="0"
    )

    # ============================================
    # INSTALL EXTENSIONS
    # ============================================
    log_header "📦 Installing GNOME Extensions"
    
    local SUCCESS=()
    local FAILED=()
    local total=${#EXTENSIONS[@]}
    local count=0

    for ext in "${EXTENSIONS[@]}"; do
        count=$((count + 1))
        log_info "[$count/$total] Installing: $ext"
        
        if sudo -u "$REAL_USER" "$GEXT" install "$ext" 2>/dev/null; then
            log_success "✅ $ext installed"
            SUCCESS+=("$ext")
        else
            local pk="${PK_MAP[$ext]:-}"
            if [[ -n "$pk" ]] && [[ "$pk" != "0" ]]; then
                log_info "Retrying with PK: $pk"
                if sudo -u "$REAL_USER" "$GEXT" install "$pk" 2>/dev/null; then
                    log_success "✅ $ext installed (PK $pk)"
                    SUCCESS+=("$ext")
                else
                    log_error "❌ Failed: $ext"
                    FAILED+=("$ext")
                fi
            else
                log_error "❌ Failed: $ext"
                FAILED+=("$ext")
            fi
        fi
    done

    # ============================================
    # ENABLE EXTENSIONS
    # ============================================
    log_header "🔓 Enabling Extensions"
    
    for ext in "${SUCCESS[@]}"; do
        sudo -u "$REAL_USER" "$GEXT" enable "$ext" 2>/dev/null || true
    done

    # ============================================
    # RESTART GNOME SHELL
    # ============================================
    log_header "🔄 Restarting GNOME Shell"
    
    if busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'global.reexec_self()' 2>/dev/null; then
        log_success "GNOME Shell restarted"
    else
        log_warn "Manual restart: Alt+F2 -> r -> Enter"
    fi

    # ============================================
    # INSTALL SYSTEM MONITORS
    # ============================================
    log_header "📊 Installing System Monitors"
    pacman -S --needed --noconfirm gnome-system-monitor btop 2>/dev/null || true
    log_success "gnome-system-monitor & btop installed"

    # ============================================
    # FINAL REPORT
    # ============================================
    log_header "📊 Installation Report"
    
    log_info "Successful (${#SUCCESS[@]}):"
    for ext in "${SUCCESS[@]}"; do
        log_info "  ✅ $ext"
    done
    
    if [[ ${#FAILED[@]} -gt 0 ]]; then
        log_warn "Failed (${#FAILED[@]}):"
        for ext in "${FAILED[@]}"; do
            log_warn "  ❌ $ext"
        done
    fi
    
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "Total: ${#SUCCESS[@]} installed, ${#FAILED[@]} failed"
    log_success "🎯 GNOME Extensions installation complete!"
}
EOF

# gpu.sh
sudo tee "$VEX_ROOT/lib/modules/gpu.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX GPU Module
install_gpu_drivers() {
    log_header "🎮 GPU Drivers"
    gpu_type=""
    if lspci | grep -qi nvidia; then
        gpu_type="nvidia"
    elif lspci | grep -qi amd; then
        gpu_type="amd"
    elif lspci | grep -qi intel; then
        gpu_type="intel"
    else
        log_info "No dedicated GPU detected"
        return 0
    fi
    log_info "Detected GPU: $gpu_type"
    driver_file="$CONFIGS_DIR/gpu/drivers.txt"
    [[ ! -f "$driver_file" ]] && { log_warn "Drivers list not found"; return 0; }
    packages=()
    while IFS='|' read -r gpu pkg desc; do
        [[ -z "$gpu" || "$gpu" =~ ^# ]] && continue
        [[ "$gpu" == "$gpu_type" ]] && packages+=("$pkg")
    done < "$driver_file"
    if [[ ${#packages[@]} -gt 0 ]]; then
        log_info "Installing: ${packages[*]}"
        pacman -S --needed --noconfirm "${packages[@]}" 2>/dev/null || log_warn "Some drivers failed"
        log_success "GPU drivers installed"
    fi
}
EOF

# mirrors.sh
sudo tee "$VEX_ROOT/lib/modules/mirrors.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Mirrors Module
configure_mirrors() {
    log_header "📡 Configuring Mirrors"
    [[ ! -f "$CONFIGS_DIR/mirrors.txt" ]] && { log_warn "Mirrors list not found"; return 0; }
    echo "# VEX Mirrors - $(date)" > /etc/pacman.d/mirrorlist
    grep -v '^#' "$CONFIGS_DIR/mirrors.txt" | cut -d'|' -f3 | while read -r m; do
        [[ -n "$m" ]] && echo "Server = ${m}/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
    done
    pacman -Syy --noconfirm 2>/dev/null || true
    log_success "Mirrors configured"
}
EOF

# services.sh
sudo tee "$VEX_ROOT/lib/modules/services.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Services Module
enable_services() {
    log_header "🔧 Services"
    services=()
    if [[ -f "$CONFIGS_DIR/services.txt" ]]; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" =~ ^# ]] && continue
            services+=("$line")
        done < "$CONFIGS_DIR/services.txt"
    else
        services=("NetworkManager" "sshd")
    fi
    for svc in "${services[@]}"; do
        if systemctl list-unit-files | grep -q "${svc}.service"; then
            systemctl enable --now "${svc}.service" 2>/dev/null && log_success "$svc enabled" || log_warn "Failed to enable $svc"
        fi
    done
}
EOF

# fun.sh
sudo tee "$VEX_ROOT/lib/modules/fun.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Fun Tools Module
install_fun_tools() {
    log_header "🎮 Installing Fun Tools"

    tools=(
        "cowsay"
        "figlet"
        "cmatrix"
        "lolcat"
        "fortune-mod"
        "sl"
        "nyancat"
        "boxes"
        "toilet"
        "asciiquarium"
        "cbonsai"
        "cava"
        "cool-retro-term"
        "neofetch"
    )

    for tool in "${tools[@]}"; do
        if is_installed "$tool"; then
            log_info "⏭️ $tool already installed"
            continue
        fi
        log_info "Installing: $tool"
        if pacman -S --needed --noconfirm "$tool" 2>/dev/null; then
            log_success "✅ $tool (official)"
        elif command_exists yay && sudo -u "$REAL_USER" yay -S --needed --noconfirm "$tool" 2>/dev/null; then
            log_success "✅ $tool (AUR)"
        else
            log_error "❌ Failed: $tool"
        fi
    done
}
EOF

# packages.sh (placeholder)
sudo tee "$VEX_ROOT/lib/modules/packages.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Packages Module - Placeholder
EOF

# postinstall.sh (placeholder)
sudo tee "$VEX_ROOT/lib/modules/postinstall.sh" > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX PostInstall Module - Placeholder
EOF

log_success "Modules created"

# ================================================================
# Create config files
# ================================================================
log_header "⚙️ Creating Config Files"

# mirrors.txt
sudo tee "$VEX_ROOT/config/mirrors.txt" > /dev/null << 'EOF'
# VEX Mirrors
Global|Worldwide|https://geo.mirror.pkgbuild.com/archlinux
Iran|Iran|https://mirror.aminol.com/archlinux
Iran|Iran|https://repo.iut.ac.ir/archlinux
Iran|Iran|https://mirror.iranserver.com/archlinux
US|USA|https://mirrors.kernel.org/archlinux
DE|Germany|https://archlinux.thaller.ws/archlinux
NL|Netherlands|https://mirror.nforce.com/pub/linux/archlinux
CN|China|https://mirrors.tuna.tsinghua.edu.cn/archlinux
JP|Japan|https://ftp.jaist.ac.jp/pub/Linux/ArchLinux
EOF

# services.txt
sudo tee "$VEX_ROOT/config/services.txt" > /dev/null << 'EOF'
NetworkManager
sshd
bluetooth
cups
EOF

# gnome configs
mkdir -p "$VEX_ROOT/config/gnome"
sudo tee "$VEX_ROOT/config/gnome/extensions.txt" > /dev/null << 'EOF'
blur-my-shell@aunetx|Blur My Shell|3193
dash-to-dock@micxgx.gmail.com|Dash to Dock|307
arcmenu@arcmenu.com|ArcMenu|3628
user-theme@gnome-shell-extensions.gcampax.github.com|User Themes|19
gsconnect@andyholmes.github.io|GSConnect|1319
clipboard-indicator@tudmotu.com|Clipboard Indicator|779
EOF

sudo tee "$VEX_ROOT/config/gnome/icons.txt" > /dev/null << 'EOF'
tela-circle-icon-theme|Tela Circle|aur
zafiro-icon-theme|Zafiro|aur
papirus-icon-theme|Papirus|pacman
EOF

sudo tee "$VEX_ROOT/config/gnome/cursors.txt" > /dev/null << 'EOF'
bibata-cursor-theme|Bibata Modern|aur
EOF

sudo tee "$VEX_ROOT/config/gnome/settings.txt" > /dev/null << 'EOF'
org.gnome.desktop.interface|gtk-theme|Orchis-Dark
org.gnome.desktop.interface|icon-theme|Tela-circle
org.gnome.desktop.interface|cursor-theme|Bibata-Modern-Classic
org.gnome.desktop.interface|cursor-size|24
org.gnome.desktop.interface|font-name|Vazir 11
EOF

# gpu
mkdir -p "$VEX_ROOT/config/gpu"
sudo tee "$VEX_ROOT/config/gpu/drivers.txt" > /dev/null << 'EOF'
nvidia|nvidia|NVIDIA Driver
nvidia|nvidia-lts|NVIDIA LTS
nvidia|nvidia-utils|NVIDIA Utils
nvidia|nvidia-settings|NVIDIA Settings
amd|mesa|Mesa Graphics
amd|vulkan-radeon|Vulkan Radeon
amd|xf86-video-amdgpu|Xorg AMDGPU
intel|mesa|Intel Graphics
intel|vulkan-intel|Vulkan Intel
EOF

# fastfetch
mkdir -p "$VEX_ROOT/config/fastfetch"
sudo tee "$VEX_ROOT/config/fastfetch/logo.txt" > /dev/null << 'EOF'
-@@@@=%@@@*.             =@@@@=@@@@=.      .#@@@#+@@@@:
 -@@@@=@@@@+           :*.-@@@@+%@@@+     :%@@@+%@@@*.
 .+@@@@+@@@@-          *@%:.%@@@*#@@@#.  -@@@@=@@@@=.
  .%@@@#+@@@%.        +@@@@:.%@@@#*@@@%.=@@@%+@@@@:.
   .%@@@#*@@@#.     .=@@@@%@+.+@@@@+@@**@@@**@@@#..
    :@@@@*%@@@+.    .@@@@=@@@*.-@@@@=+%@@@+%@@@+.
    .=@@@@-@@@@-   .@@@@=@@@@*. :%@@@@@@%-@@@@:..
      +@@@@=@@@@: .*@@@*%@@@#..  .#@@@@#*@@@%:
      .*@@@%*@@@%.=@@@#+@@@@:.  ..@@@@@@+@@@@:
       .@@@@*#@@@=@@@%+@@@@:    :@@@@@@@@=@@@@=
        .@@@@+%@+@@@@+@@@@=.  .=@@@%++%@@@+%@@@+.
         -@@@@++#@@@-%@@@*..  *@@@#+@@+%@@@+#@@@%.
         .+@@@%#@@@+%@@@#.  :%@@@+%@@@+.*@@@#*@@@%:
           *@@@@@@#*@@@%:  :@@@@=%@@@=.  *@@@%=@@@@-.
           .#@@@@@@+@@@:..+@@@%+@@@@:     =@@@@+@@@@+
            :@@@@@@%=@-..*@@@**@@@%:.      -@@@@=#@@@#.
             .******+...+***-+***=          .+***=+***+.
EOF

sudo tee "$VEX_ROOT/config/fastfetch/config.jsonc" > /dev/null << 'EOF'
{
  "logo": {
    "type": "file",
    "source": "/usr/share/vex/config/fastfetch/logo.txt",
    "padding": { "right": 4 },
    "color": { "1": "#e64b40", "2": "#e8d5d5" }
  },
  "display": {
    "separator": " ",
    "color": { "keys": "#d6956f", "title": "#e8d5d5", "values": "#e8d5d5" }
  },
  "modules": [
    {"key": "╭───────────╮", "type": "custom", "color": "$border_color"},
    {"key": "│  user    │", "type": "title", "format": "{user-name}", "color": "$user_color"},
    {"key": "│ 󰇅 hname   │", "type": "title", "format": "{host-name}", "color": "$host_color"},
    {"key": "│ 󰅐 uptime  │", "type": "uptime", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│  kernel  │", "type": "kernel", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰘳 wm      │", "type": "wm", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰇄 desktop │", "type": "de", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│  term    │", "type": "terminal", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│  shell   │", "type": "shell", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰍛 cpu     │", "type": "cpu", "showPeCoreCount": true, "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰉉 disk    │", "type": "disk", "folders": "/", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "│ 󰑭 memory  │", "type": "memory", "keyColor": "$arrow_color", "color": "$foreground"},
    {"key": "├───────────┤", "type": "custom", "color": "$border_color"},
    {"key": "│ ● colors  │", "type": "colors", "symbol": "circle", "keyColor": "$arrow_color"},
    {"key": "╰───────────╯", "type": "custom", "color": "$border_color"}
  ]
}
EOF

# fish
mkdir -p "$VEX_ROOT/config/fish"
sudo tee "$VEX_ROOT/config/fish/config.fish" > /dev/null << 'EOF'
# VEX-OS Fish Config
set -gx EDITOR nvim
set -gx BROWSER firefox
set -gx TERMINAL kitty

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias clean='sudo pacman -Scc'

set -g fish_greeting

function fish_prompt
    set -l color_user     c46a6a
    set -l color_host     d4b8a8
    set -l color_path     e8d5d5
    set -l color_git      8a9a7a
    set -l color_arrow    d4b8a8
    set -l color_border   6a4a4a

    set -l user (whoami)
    set -l host (uname -n 2>/dev/null; or echo "vx")
    set -l pwd (prompt_pwd)

    set_color $color_border
    echo -n "╭──"

    set_color $color_user
    echo -n "$user"

    set_color $color_border
    echo -n "@"

    set_color $color_host
    echo -n "$host"

    set_color $color_border
    echo -n " ── "

    set_color $color_path
    echo -n "$pwd"

    echo ""

    set_color $color_border
    echo -n "╰──"
    set_color $color_arrow
    echo -n "❯ "
    set_color normal
end

if command -v fastfetch &>/dev/null
    fastfetch
end

setxkbmap ir 2>/dev/null
EOF

# kitty
mkdir -p "$VEX_ROOT/config/kitty"
sudo tee "$VEX_ROOT/config/kitty/kitty.conf" > /dev/null << 'EOF'
# VEX-OS Kitty Terminal
background_opacity 0.88
dynamic_background_opacity yes
background_blur 8

window_padding_width  18
window_padding_height 16

window_border_width 2
window_border_color #6a4a4a
active_window_border_color #c46a6a
inactive_window_border_color #3a2a2a
window_rounded_corners 14

cursor_shape            block
cursor_blink_interval   0
cursor_text_color       #1a1414
cursor_color            #c46a6a

selection_foreground    #1a1414
selection_background    #c46a6a

background #1a1414
foreground #e8d5d5

color0 #2a1a1a
color8 #4a2a2a

color1 #c46a6a
color9 #d48a7a

color2  #8a9a7a
color10 #9aaa8a

color3  #d4b8a8
color11 #e4c8b8

color4  #7a8aa8
color12 #8a9ab8

color5  #b08a9a
color13 #c09aaa

color6  #7a9a8a
color14 #8aaaaa

color7  #d0c0b8
color15 #e8d8d0

font_family      JetBrainsMono Nerd Font
font_size        12.5
adjust_line_height  2

map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map ctrl+shift+f toggle_fullscreen

scrollback_lines 10000

renderer opengl
sync_to_monitor no

enable_audio_bell no
confirm_os_window_close 0
strip_trailing_spaces smart
shell_integration enabled

mouse_hide_wait 2.0
url_color #d4b8a8
url_style curly
open_url_modifiers ctrl+shift
EOF

log_success "Config files created"

# ================================================================
# Create package lists (15 categories)
# ================================================================
log_header "📋 Creating Package Lists (15 Categories)"

# 00-core.txt
sudo tee "$VEX_ROOT/packages-lists/00-core.txt" > /dev/null << 'EOF'
# Core - Essential System Packages
base
base-devel
linux
linux-headers
linux-firmware
grub
efibootmgr
networkmanager
iwd
dhcpcd
openssh
sudo
systemd
dbus
polkit
util-linux
EOF

# 01-base.txt
sudo tee "$VEX_ROOT/packages-lists/01-base.txt" > /dev/null << 'EOF'
# Base - Core Utilities
vim
nano
git
curl
wget
htop
btop
fastfetch
neofetch
unzip
zip
tar
gzip
zstd
p7zip
rsync
tree
jq
yq
pacman-contrib
reflector
eza
bat
ripgrep
fd
fzf
tmux
screen
micro
EOF

# 02-desktop.txt
sudo tee "$VEX_ROOT/packages-lists/02-desktop.txt" > /dev/null << 'EOF'
# Desktop - GNOME Environment
gnome
gnome-tweaks
gnome-shell-extensions
gnome-software
gnome-system-monitor
gnome-terminal
nautilus
firefox
chromium
kitty
fish
vazir-fonts
ttf-jetbrains-mono
noto-fonts
adwaita-icon-theme
papirus-icon-theme
EOF

# 03-dev.txt
sudo tee "$VEX_ROOT/packages-lists/03-dev.txt" > /dev/null << 'EOF'
# Development - Programming Tools
gcc
g++
make
cmake
autoconf
automake
pkg-config
python
python-pip
python-virtualenv
nodejs
npm
yarn
go
rust
cargo
ruby
php
composer
docker
docker-compose
neovim
visual-studio-code-bin
cursor-bin
sublime-text-4
zed
codeblocks
geany
micro
EOF

# 04-pentest-light.txt
sudo tee "$VEX_ROOT/packages-lists/04-pentest-light.txt" > /dev/null << 'EOF'
# Pentest Light - Essential Security Tools
nmap
masscan
amass
subfinder
theharvester
dnsrecon
enum4linux
fierce
sqlmap
ffuf
gobuster
wfuzz
nikto
whatweb
dirsearch
wpscan
metasploit
exploitdb
searchsploit
responder
impacket
wireshark-qt
tcpdump
ettercap
macchanger
arp-scan
netdiscover
john
hydra
crunch
cewl
hashid
aircrack-ng
reaver
kismet
sherlock
maigret
holehe
photon
metagoofil
EOF

# 05-pentest-pro.txt
sudo tee "$VEX_ROOT/packages-lists/05-pentest-pro.txt" > /dev/null << 'EOF'
# PENTEST PRO - Advanced Security Toolkit (500+ Tools)
# Subcategories: Recon, Web, Exploit, Network, Credential, Social, C2, Wireless, Privesc, OSINT, Serialization
# Use: vex-pkg show Pentest-Pro <sub>
EOF

# 06-gaming.txt
sudo tee "$VEX_ROOT/packages-lists/06-gaming.txt" > /dev/null << 'EOF'
# Gaming - Gaming & Entertainment
steam
lutris
wine
winetricks
protonup-qt
gamehub
mangohud
goverlay
retroarch
ppsspp
heroic-games-launcher
EOF

# 07-media.txt
sudo tee "$VEX_ROOT/packages-lists/07-media.txt" > /dev/null << 'EOF'
# Media - Multimedia & Creative
vlc
mpv
spotify
obs-studio
gimp
inkscape
blender
kdenlive
audacity
krita
darktable
rawtherapee
handbrake
ffmpeg
yt-dlp
strawberry
deadbeef
EOF

# 08-network.txt
sudo tee "$VEX_ROOT/packages-lists/08-network.txt" > /dev/null << 'EOF'
# Network - Networking & Communication
wireshark-qt
tcpdump
ettercap
openssh
openvpn
wireguard-tools
proxychains-ng
tor
telegram-desktop
discord
zoom
signal-desktop
remmina
freerdp
EOF

# 09-privacy.txt
sudo tee "$VEX_ROOT/packages-lists/09-privacy.txt" > /dev/null << 'EOF'
# Privacy - Privacy & Security Tools
tor
torbrowser-launcher
proxychains-ng
veracrypt
keepassxc
gpg
openssl
openvpn
wireguard-tools
mullvad-vpn
protonvpn-cli
expressvpn
obfs4proxy
meek
snowflake
i2pd
i2p
freenet
zeronet
onionshare
ricochet
tox
qtox
element-desktop
keybase
signal-desktop
session-desktop
mat2
exiftool
bleachbit
wipe
shred
srm
ddrescue
nwipe
macchanger
anonsurf
EOF

# 10-aur.txt
sudo tee "$VEX_ROOT/packages-lists/10-aur.txt" > /dev/null << 'EOF'
# AUR - Arch User Repository
google-chrome
visual-studio-code-bin
brave-bin
spotify
discord
obsidian-bin
localsend-bin
protonvpn-cli
zoom
slack-desktop
teamviewer
anydesk-bin
expressvpn
mullvad-vpn
v2ray
v2raya
sing-box
cool-retro-term
EOF

# 11-custom.txt
sudo tee "$VEX_ROOT/packages-lists/11-custom.txt" > /dev/null << 'EOF'
# Custom - User-defined packages
# Add your own packages here
EOF

# 12-configs.txt
sudo tee "$VEX_ROOT/packages-lists/12-configs.txt" > /dev/null << 'EOF'
# Configs - VEX Configurations (virtual)
# Applied with: vex-pkg apply configs
EOF

# 13-gpu.txt
sudo tee "$VEX_ROOT/packages-lists/13-gpu.txt" > /dev/null << 'EOF'
# GPU - Graphics Drivers
nvidia
nvidia-lts
nvidia-utils
nvidia-settings
lib32-nvidia-utils
cuda
opencl-nvidia
mesa
mesa-utils
lib32-mesa
vulkan-radeon
xf86-video-amdgpu
opencl-amd
vulkan-intel
xf86-video-intel
EOF

# 14-downloaders.txt
sudo tee "$VEX_ROOT/packages-lists/14-downloaders.txt" > /dev/null << 'EOF'
# Downloaders - Download Managers
yt-dlp
gallery-dl
jdownloader
persepolis
motrix
aria2
wget
curl
axel
uget
qbittorrent
transmission-gtk
deluge
rtorrent
webtorrent-cli
EOF

# 15-fun.txt
sudo tee "$VEX_ROOT/packages-lists/15-fun.txt" > /dev/null << 'EOF'
# Fun Tools - Entertainment & Fun
cowsay
figlet
cmatrix
lolcat
fortune-mod
sl
nyancat
boxes
toilet
asciiquarium
cbonsai
cava
cool-retro-term
neofetch
EOF

log_success "Package lists created (15 categories)"

# ================================================================
# Select theme
# ================================================================
select_theme

# ================================================================
# Apply theme to configs
# ================================================================
apply_theme_to_configs "$SELECTED_THEME"

# ================================================================
# Save theme for vex-pkg
# ================================================================
echo "$SELECTED_THEME" > "$VEX_ROOT/config/selected_theme"
log_success "Theme saved for vex-pkg"

# ================================================================
# Select configs to install
# ================================================================
select_configs

# ================================================================
# Install selected configs
# ================================================================
install_selected_configs

# ================================================================
# Install auto-completion
# ================================================================
log_header "🔧 Installing Auto-completion"

mkdir -p /usr/share/bash-completion/completions
sudo tee /usr/share/bash-completion/completions/vex-pkg > /dev/null << 'EOF'
_vex_pkg_completion() {
    local cur prev words cword
    _init_completion || return

    local commands="list show install apply doctor cleanup help"
    local categories="core base desktop dev pentest-light pentest-pro gaming media network privacy aur custom configs gpu downloaders fun-tools"
    local modules="gnome configs gpu services mirrors aur fun"

    case "${prev}" in
        show|cat)
            COMPREPLY=($(compgen -W "${categories}" -- ${cur}))
            return 0
            ;;
        install|i)
            COMPREPLY=($(compgen -W "${categories}" -- ${cur}))
            return 0
            ;;
        apply)
            COMPREPLY=($(compgen -W "${modules}" -- ${cur}))
            return 0
            ;;
    esac

    if [[ ${cword} -eq 1 ]]; then
        COMPREPLY=($(compgen -W "${commands}" -- ${cur}))
        return 0
    fi
}
complete -F _vex_pkg_completion vex-pkg
EOF

log_success "Auto-completion installed"

# ================================================================
# Install vex-pkg (with smart privilege escalation)
# ================================================================
log_header "🔧 Installing vex-pkg"

sudo tee /usr/local/bin/vex-pkg > /dev/null << 'EOF'
#!/usr/bin/env bash
# VEX Package Manager v4.0.1 - Ultimate Edition
# Creator: Vexis (https://github.com/VexisVX)

set -Eeuo pipefail

VEX_ROOT="/usr/share/vex"
source "${VEX_ROOT}/lib/core/config.sh" 2>/dev/null || { echo "[!] Core config not found"; exit 1; }
source "${VEX_ROOT}/lib/core/logging.sh" 2>/dev/null || { echo "[!] Logging not found"; exit 1; }
source "${VEX_ROOT}/lib/core/utils.sh" 2>/dev/null || { echo "[!] Utils not found"; exit 1; }
source "${VEX_ROOT}/lib/core/package.sh" 2>/dev/null || { echo "[!] Package not found"; exit 1; }

ensure_dirs

# Only escalate for subcommands that actually need root
require_root() {
    if [[ $EUID -ne 0 ]]; then
        if ! command -v sudo &>/dev/null; then
            log_error "This command needs root privileges and 'sudo' is not available."
            exit 1
        fi
        exec sudo -E "$0" "$@"
    fi
}

# ================================================================
# Load theme colors
# ================================================================
load_theme_colors() {
    theme_file="$CONFIGS_DIR/selected_theme"
    theme_name="red-white"

    if [[ -f "$theme_file" ]]; then
        theme_name=$(cat "$theme_file" 2>/dev/null || echo "red-white")
    fi

    case "$theme_name" in
        "cyberpunk")
            VEX_COLOR_PRIMARY='\033[0;35m'
            VEX_COLOR_SECONDARY='\033[0;36m'
            VEX_COLOR_ACCENT='\033[0;32m'
            VEX_COLOR_HEADER='\033[0;35;1m'
            ;;
        "nord"|"tokyo-night"|"solarized")
            VEX_COLOR_PRIMARY='\033[0;34m'
            VEX_COLOR_SECONDARY='\033[0;36m'
            VEX_COLOR_ACCENT='\033[0;32m'
            VEX_COLOR_HEADER='\033[0;34;1m'
            ;;
        "dracula"|"catppuccin"|"rose-pine")
            VEX_COLOR_PRIMARY='\033[0;35m'
            VEX_COLOR_SECONDARY='\033[0;36m'
            VEX_COLOR_ACCENT='\033[0;32m'
            VEX_COLOR_HEADER='\033[0;35;1m'
            ;;
        "gruvbox")
            VEX_COLOR_PRIMARY='\033[0;33m'
            VEX_COLOR_SECONDARY='\033[0;36m'
            VEX_COLOR_ACCENT='\033[0;32m'
            VEX_COLOR_HEADER='\033[0;33;1m'
            ;;
        "everforest")
            VEX_COLOR_PRIMARY='\033[0;32m'
            VEX_COLOR_SECONDARY='\033[0;36m'
            VEX_COLOR_ACCENT='\033[0;33m'
            VEX_COLOR_HEADER='\033[0;32;1m'
            ;;
        *)
            VEX_COLOR_PRIMARY='\033[0;31m'
            VEX_COLOR_SECONDARY='\033[0;33m'
            VEX_COLOR_ACCENT='\033[0;32m'
            VEX_COLOR_HEADER='\033[0;31;1m'
            ;;
    esac
}

load_theme_colors

# NOTE: All functions (list_categories, show_category, install_category, etc.)
# are sourced from package.sh above.

show_help() {
    echo ""
    echo -e "${VEX_COLOR_HEADER}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${VEX_COLOR_HEADER}║                    VEX PACKAGE MANAGER v4.0.1                         ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║              Creator: Vexis (github.com/VexisVX)                      ║${NC}"
    echo -e "${VEX_COLOR_HEADER}╠═══════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}  ${VEX_COLOR_PRIMARY}USAGE:${NC}                                                               ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    vex-pkg <command> [options]                                        ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}  ${VEX_COLOR_PRIMARY}COMMANDS:${NC}                                                            ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}list${NC}                             - List all categories             ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}show${NC} <category>                  - Show packages in a category     ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}show${NC} Pentest-Pro <sub>           - Show Pentest-Pro subcategory  ${VEX_COLOR_HEADER}  ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}install${NC} <category>               - Install a whole category        ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}install${NC} <pkg>                    - Install a specific package      ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}install${NC} <pkg1> <pkg2>            - Install multiple packages      ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}info${NC} <pkg>                       - Show package information       ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}search${NC} <query>                   - Search for packages            ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}apply${NC} <module>                   - Apply configuration module     ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}doctor${NC}                           - System health check            ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}cleanup${NC}                          - Clean package caches           ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}install-all${NC}                      - Install all categories         ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}install-yay${NC}                      - Install yay (AUR helper)       ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}help${NC}                             - Show this help                 ${VEX_COLOR_HEADER} ║${NC}"
    
    # =============== PENTEST-PRO ===============
    echo -e "${VEX_COLOR_HEADER}║${NC}  ${VEX_COLOR_PRIMARY}PENTEST-PRO SUBCATEGORIES:${NC}                                           ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}Recon${NC}, ${VEX_COLOR_ACCENT}Web${NC}, ${VEX_COLOR_ACCENT}Exploit${NC}, ${VEX_COLOR_ACCENT}Network${NC}, ${VEX_COLOR_ACCENT}Credential${NC}   ${VEX_COLOR_HEADER}                        ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}Social${NC}, ${VEX_COLOR_ACCENT}C2${NC}, ${VEX_COLOR_ACCENT}Wireless${NC}, ${VEX_COLOR_ACCENT}Privesc${NC}, ${VEX_COLOR_ACCENT}OSINT${NC}       ${VEX_COLOR_HEADER}                        ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}Serialization${NC}                                                      ${VEX_COLOR_HEADER}║${NC}"
    
    # =============== CUSTOM & CONFIGS ===============
    echo -e "${VEX_COLOR_HEADER}║${NC}  ${VEX_COLOR_PRIMARY}CUSTOM CATEGORIES:${NC}                                                   ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}Custom${NC}  - Add your own packages:                                   ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}              ${YELLOW}sudo nano /usr/share/vex/packages-lists/11-custom.txt${NC}    ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}              ${YELLOW}sudo vex-pkg install custom${NC}                              ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}Configs${NC} - Apply system configurations:                             ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}              ${YELLOW}sudo vex-pkg apply configs${NC}                               ${VEX_COLOR_HEADER}║${NC}"
    
    # =============== MODULES ===============
    echo -e "${VEX_COLOR_HEADER}║${NC}  ${VEX_COLOR_PRIMARY}AVAILABLE MODULES:${NC}                                                   ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}gnome${NC}    - Setup GNOME extensions, icons, cursors, settings       ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}configs${NC}  - Apply Fastfetch, Kitty, Fish configs                   ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}gpu${NC}      - Install GPU drivers (NVIDIA/AMD/Intel)                 ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}services${NC} - Enable system services (NetworkManager, sshd, etc)     ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}mirrors${NC}  - Configure pacman mirrors                                ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}aur${NC}      - Install yay (AUR helper)                               ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}fun${NC}      - Install fun tools (cowsay, figlet, cmatrix, etc)       ${VEX_COLOR_HEADER} ║${NC}"
    
    # =============== GNOME EXTENSIONS DETAIL ===============
    echo -e "${VEX_COLOR_HEADER}║${NC}  ${VEX_COLOR_PRIMARY}GNOME EXTENSIONS:${NC}                                                    ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}apply gnome${NC} installs these extensions:                             ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}      • Blur My Shell             • Dash to Dock               ${VEX_COLOR_HEADER}        ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}      • ArcMenu                   • User Themes                 ${VEX_COLOR_HEADER}       ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}      • GSConnect                 • Clipboard Indicator          ${VEX_COLOR_HEADER}      ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${YELLOW}Add more: sudo nano /usr/share/vex/config/gnome/extensions.txt${NC}     ${VEX_COLOR_HEADER}║${NC}"
    
    # =============== EXAMPLES ===============
    echo -e "${VEX_COLOR_HEADER}║${NC}  ${VEX_COLOR_PRIMARY}EXAMPLES:${NC}                                                            ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}vex-pkg install kitty${NC}             # Install specific package      ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}vex-pkg install kitty fish${NC}        # Install multiple packages     ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}vex-pkg install desktop${NC}           # Install whole category        ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}vex-pkg show Pentest-Pro Web${NC}      # Show Pentest-Pro Web tools    ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}vex-pkg info kitty${NC}                # Show package info              ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}vex-pkg search terminal${NC}           # Search for packages            ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}sudo vex-pkg apply gnome${NC}          # Setup GNOME extensions & theme ${VEX_COLOR_HEADER}║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}sudo vex-pkg apply configs${NC}        # Apply Fastfetch, Kitty, Fish  ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}sudo vex-pkg apply fun${NC}            # Install fun tools             ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}║${NC}    ${VEX_COLOR_ACCENT}sudo vex-pkg doctor${NC}               # Health check                  ${VEX_COLOR_HEADER} ║${NC}"
    echo -e "${VEX_COLOR_HEADER}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ================================================================
# Dispatcher
# ================================================================
case "${1:-help}" in
    info)
        show_pkg_info "${2:-}"
        ;;
    search)
        search_packages "${2:-}"
        ;;
    install|i)
        require_root "$@"
        shift
        if [[ $# -eq 0 ]]; then
            log_error "Usage: vex-pkg install <package1> <package2> ..."
            log_info "Or: vex-pkg install <category>"
            exit 1
        fi
        first="$1"
        if [[ -f "$PKG_LISTS/${first}.txt" ]] || [[ -n "${CATEGORY_ALIASES[$first]:-}" ]]; then
            if [[ $# -eq 1 ]]; then
                install_category "$first"
            else
                install_specific_packages "$@"
            fi
        else
            install_specific_packages "$@"
        fi
        ;;
    list|ls)
        list_categories
        ;;
    show|cat)
        if [[ "${2:-}" == "Pentest-Pro" ]] || [[ "${2:-}" == "pentest-pro" ]] || [[ "${2:-}" == "05-pentest-pro" ]]; then
            show_category "$2" "${3:-}"
        else
            show_category "${2:-}"
        fi
        ;;
    apply)
        require_root "$@"
        apply_module "${2:-}"
        ;;
    doctor)
        cmd_doctor
        ;;
    cleanup)
        require_root "$@"
        cmd_cleanup
        ;;
    install-all|all)
        require_root "$@"
        install_all_categories
        ;;
    install-yay)
        require_root "$@"
        source "${MODULES_DIR}/aur.sh" && install_yay
        ;;
    help|-h|--help)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run: vex-pkg help"
        exit 1
        ;;
esac
EOF

chmod +x /usr/local/bin/vex-pkg
log_success "vex-pkg installed"

# ================================================================
# Verify installation
# ================================================================
log_header "🔍 Verification"

verify_file() {
    if [[ -f "$1" ]]; then
        echo -e "  ${GREEN}✅${NC} $1"
        return 0
    else
        echo -e "  ${RED}❌${NC} $1"
        return 1
    fi
}

echo ""
echo -e "${BOLD}Executable:${NC}"
verify_file "/usr/local/bin/vex-pkg"

echo ""
echo -e "${BOLD}Package lists:${NC}"
for p in 00-core 01-base 02-desktop 03-dev 04-pentest-light 05-pentest-pro 06-gaming 07-media 08-network 09-privacy 10-aur 11-custom 12-configs 13-gpu 14-downloaders 15-fun; do
    verify_file "$VEX_ROOT/packages-lists/${p}.txt"
done

# ================================================================
# Final Summary
# ================================================================
log_header "✅ VEX Installation Complete!"

echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ VEX installed to: $VEX_ROOT${NC}"
echo -e "${GREEN}✓ Executable: /usr/local/bin/vex-pkg${NC}"
echo -e "${GREEN}✓ Categories: 15 categories${NC}"
echo -e "${GREEN}✓ Theme: $SELECTED_THEME applied${NC}"
echo -e "${GREEN}✓ Creator: Vexis (github.com/VexisVX)${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"

echo ""
echo -e "${BOLD}${CYAN}Quick Start:${NC}"
echo "  vex-pkg list              - View all categories"
echo "  vex-pkg show Core         - Show Core category"
echo "  vex-pkg show Pentest-Pro  - Show Pentest Pro category"
echo "  sudo vex-pkg install Base - Install Base category"
echo "  sudo vex-pkg install network - Install Network category"
echo "  sudo vex-pkg install proxychains-ng - Install specific package"
echo "  sudo vex-pkg apply configs - Apply Fastfetch, Kitty, Fish configs"
echo "  sudo vex-pkg apply gnome  - Setup GNOME extensions & themes"
echo "  sudo vex-pkg apply fun    - Install fun tools (cowsay, figlet, cmatrix...)"
echo "  sudo vex-pkg doctor       - Health check"
echo "  vex-pkg help              - Show full help"
echo ""

echo -e "${BOLD}${YELLOW}Optional:${NC}"
echo "  sudo vex-pkg install-yay  - Install yay (AUR helper)"
echo ""

if [[ $ERROR_COUNT -gt 0 || $WARNING_COUNT -gt 0 ]]; then
    log_warn "Completed with ${ERROR_COUNT} error(s) and ${WARNING_COUNT} warning(s) during setup."
fi

log_success "🎯 VEX is ready to use!"

exit 0
