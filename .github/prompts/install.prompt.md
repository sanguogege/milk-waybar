---
description: "Deploy milk-waybar configuration to Fedora + niri system: install dependencies, copy/symlink config files, restart waybar"
name: "Deploy Waybar Config"
argument-hint: "Deployment mode (copy/symlink) and any customizations"
agent: "agent"
tools: [search]
---

# Deploy milk-waybar to Fedora + niri

Deploy this Waybar configuration to a Fedora minimal installation running the **niri** Wayland compositor.

## Steps

### 1. Install Dependencies

Install required packages via `dnf`:

- `waybar` — status bar
- `pulseaudio` / `pipewire-pulseaudio` — audio module
- `network-manager-applet` — network module (if needed)
- `bluez`, `blueman` — Bluetooth module (if needed)
- `fontawesome` / `fonts-font-awesome` — icon fonts
- `python3-dbus` — for custom scripts (if any)

```bash
sudo dnf install -y waybar pulseaudio pipewire-pulseaudio network-manager-applet blueman fontawesome-fonts python3-dbus
```

> **Note**: niri is installed separately via copr or flathub; this prompt only covers Waybar setup.

### 2. Backup Existing Config

```bash
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar.bak.$(date +%Y%m%d%H%M%S)
```

### 3. Deploy Config Files

Choose one method:

#### Option A: Copy files (recommended for first-time setup)

```bash
mkdir -p ~/.config/waybar
cp -r config.jsonc modules/ styles/ themes/ scripts/ ~/.config/waybar/
```

#### Option B: Symbolic links (for development, live edits reflect immediately)

```bash
ln -sf "$(pwd)" ~/.config/waybar
```

### 4. Adapt for niri (if needed)

The current `config.jsonc` includes hyprland modules. If you're using **niri** instead of Hyprland, remove or replace hyprland-specific entries:

- Remove `"hyprland/language"` from `modules-center`
- Add niri-compatible modules as needed

Edit `config.jsonc` accordingly:

```bash
# Example: comment out hyprland modules
sed -i 's/"hyprland\/language"/\/\/ "hyprland\/language"/' ~/.config/waybar/config.jsonc
```

### 5. Restart Waybar

```bash
killall waybar 2>/dev/null
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/styles/index.css &
```

Or, if using systemd user service:

```bash
systemctl --user restart waybar
```

## Verification

Check that Waybar is running and showing the correct modules:

```bash
ps aux | grep waybar
```

If the bar is not visible, check logs:

```bash
journalctl --user -u waybar -n 50 --no-pager
```

## Arguments

This prompt accepts optional context via selected code or chat input:
- **Selected text**: A custom module JSONC or CSS snippet to include in the deployment
- **Chat argument**: Deployment mode — `copy`, `symlink`, or specific module name to configure
