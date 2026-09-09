# Sober Optimizer
<img width="1245" height="519" alt="image" src="https://github.com/user-attachments/assets/422ba9f1-41da-4de1-b649-c0705181f21d" />

A terminal-based interactive configuration tool for [Sober](https://vinegarhq.org/Sober/), the Roblox client for Linux.

## What it does

Guides you through the most impactful Sober settings with clear explanations for each option, then writes the config file directly to the correct location — keeping Sober's original header comments intact.

## Requirements

- Linux with Sober installed via Flatpak
- Bash

## Usage

```bash
chmod +x install.sh
./install.sh
```

## Configurable options

| Option | Default (Sober) | Optimized | Description |
|--------|----------------|-----------|-------------|
| `graphics_optimization_mode` | `balanced` | `performance` | Prioritizes FPS over visual quality |
| `DFIntDebugFRMQualityLevelOverride` | *(disabled)* | `1` | Forces Roblox render quality level (1 = min, 21 = max) |
| `discord_rpc_enabled` | `false` | `true` | Shows Roblox activity on Discord status |
| `discord_rpc_show_join_button` | `false` | `true` | Lets friends join your game from Discord |
| `enable_gamemode` | `true` | `true` | Prioritizes system resources for the game (Linux GameMode) |
| `allow_gamepad_permission` | `false` | `false` | Enables controller/gamepad support |

## Behavior

- Reads your **current config** before asking anything — already optimized values are detected and reported as unchanged
- Shows the **current value** and the **recommended value** for each option
- Offers an optional timestamped backup in your home folder before saving
- If **nothing changed**, the config is not rewritten
- Displays a **summary** with highlighted changes before saving
- Preserves Sober's original `// !!! STOP !!!` header comments in the output file

## Config location

```
~/.var/app/org.vinegarhq.Sober/config/sober/config.json
```

Backups are saved in `$HOME` with a timestamped name such as
`sober-config.json.backup-20260909-153000`.

## Notes

- Deleting the config file and launching Sober will restore it to defaults
- Official documentation: https://vinegarhq.org/Sober/Configuration/index.html
