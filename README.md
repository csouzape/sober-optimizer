# Sober Optimizer
<img width="1246" height="760" alt="image" src="https://github.com/user-attachments/assets/23543a0d-b9f7-4583-8619-a4218dc9fa29" />

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
- If **nothing changed**, the config is not rewritten
- Displays a **summary** with highlighted changes before saving
- Preserves Sober's original `// !!! STOP !!!` header comments in the output file

## Config location

```
~/.var/app/org.vinegarhq.Sober/config/sober/config.json
```

## Notes

- Deleting the config file and launching Sober will restore it to defaults
- Official documentation: https://vinegarhq.org/Sober/Configuration/index.html
