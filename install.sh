#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m'

CONFIG_DEST="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"

DEFAULT_GRAPHICS_MODE="balanced"
DEFAULT_FRM_FLAG="FFlagExample"
DEFAULT_FRM_VALUE=""
DEFAULT_DISCORD_RPC=false
DEFAULT_DISCORD_JOIN=false
DEFAULT_GAMEMODE=true
DEFAULT_GAMEPAD=false

CONFIG_HEADER='// !!! STOP !!!
// This file is not meant to be edited by hand unless you know what you are doing. You are encouraged to use the settings menu instead (Right click Sober in your apps menu, then hit "Settings")
// You can prevent Sober from launching by improperly formatting this file'"'"'s JSON, or possibly mess up the Roblox engine by toggling certain flags intended for Roblox engineers.
// Incase you mess up, you can reset this file by deleting it. It will be recreated the next time you launch Sober.
// -------------------------------------------
// Documentation is available at https://vinegarhq.org/Sober/Configuration/index.html - We encourage you to read it before toggling anything.'

print_banner() {
    echo -e "${MAGENTA}"
    echo "  ██████╗  ██████╗ ██████╗ ███████╗██████╗ "
    echo "  ██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔══██╗"
    echo "  ███████╗██║   ██║██████╔╝█████╗  ██████╔╝"
    echo "  ╚════██║██║   ██║██╔══██╗██╔══╝  ██╔══██╗"
    echo "  ███████║╚██████╔╝██████╔╝███████╗██║  ██║"
    echo "  ╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝"
    echo -e "${CYAN}"
    echo "  ██████╗ ██████╗ ████████╗██╗███╗   ███╗██╗███████╗███████╗██████╗ "
    echo "  ██╔══██╗██╔══██╗╚══██╔══╝██║████╗ ████║██║╚══███╔╝██╔════╝██╔══██╗"
    echo "  ██║  ██║██████╔╝   ██║   ██║██╔████╔██║██║  ███╔╝ █████╗  ██████╔╝"
    echo "  ██║  ██║██╔═══╝    ██║   ██║██║╚██╔╝██║██║ ███╔╝  ██╔══╝  ██╔══██╗"
    echo "  ██████╔╝██║        ██║   ██║██║ ╚═╝ ██║██║███████╗███████╗██║  ██║"
    echo "  ╚═════╝ ╚═╝        ╚═╝   ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝"
    echo -e "${NC}"
}

ask_yn() {
    local question="$1"
    local answer
    local prompt
    while true; do
        prompt="${YELLOW}${question} ${WHITE}[y/n]${NC}  > "
        read -r -p "$prompt" answer
        case "$answer" in
            y|Y) return 0 ;;
            n|N) return 1 ;;
            *) echo -e "${RED}  Invalid answer. Type y or n.${NC}" ;;
        esac
    done
}

read_current_config() {
    if [ ! -f "$CONFIG_DEST" ]; then
        return
    fi
    _cfg_graphics=$(grep -o '"graphics_optimization_mode": *"[^"]*"' "$CONFIG_DEST" | grep -o '"[^"]*"$' | tr -d '"')
    _cfg_frm=$(grep -o '"DFIntDebugFRMQualityLevelOverride": *[0-9]*' "$CONFIG_DEST" | grep -o '[0-9]*$')
    _cfg_discord_rpc=$(grep -o '"discord_rpc_enabled": *[a-z]*' "$CONFIG_DEST" | grep -o '[a-z]*$')
    _cfg_discord_join=$(grep -o '"discord_rpc_show_join_button": *[a-z]*' "$CONFIG_DEST" | grep -o '[a-z]*$')
    _cfg_gamemode=$(grep -o '"enable_gamemode": *[a-z]*' "$CONFIG_DEST" | grep -o '[a-z]*$')
    _cfg_gamepad=$(grep -o '"allow_gamepad_permission": *[a-z]*' "$CONFIG_DEST" | grep -o '[a-z]*$')
}

configure_sober() {
    clear
    print_banner

    read_current_config

    CUR_GRAPHICS="${_cfg_graphics:-$DEFAULT_GRAPHICS_MODE}"
    CUR_FRM="${_cfg_frm:-}"
    CUR_DISCORD_RPC="${_cfg_discord_rpc:-$DEFAULT_DISCORD_RPC}"
    CUR_DISCORD_JOIN="${_cfg_discord_join:-$DEFAULT_DISCORD_JOIN}"
    CUR_GAMEMODE="${_cfg_gamemode:-$DEFAULT_GAMEMODE}"
    CUR_GAMEPAD="${_cfg_gamepad:-$DEFAULT_GAMEPAD}"

    GRAPHICS_MODE="$CUR_GRAPHICS"
    FRM_VALUE="${CUR_FRM:-1}"
    FRM_ENABLED=false
    [ -n "$CUR_FRM" ] && FRM_ENABLED=true
    DISCORD_RPC="$CUR_DISCORD_RPC"
    DISCORD_JOIN="$CUR_DISCORD_JOIN"
    GAMEMODE="$CUR_GAMEMODE"
    GAMEPAD="$CUR_GAMEPAD"

    CHANGED=false

    echo -e "${BLUE}╔═════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${WHITE}           Sober Configuration           ${BLUE}║${NC}"
    echo -e "${BLUE}╚═════════════════════════════════════════╝${NC}\n"

    echo -e "${CYAN}┌─ Graphics Optimization Mode${NC}"
    echo -e "${WHITE}│  Prioritizes FPS over visual quality.${NC}"
    echo -e "${WHITE}│  Current: ${YELLOW}$CUR_GRAPHICS${NC}"
    echo -e "${WHITE}│  Optimized value: ${GREEN}performance${NC}"
    if ask_yn "│  Enable performance graphics mode?"; then
        NEW_GRAPHICS="performance"
    else
        NEW_GRAPHICS="balanced"
    fi
    [ "$NEW_GRAPHICS" != "$CUR_GRAPHICS" ] && CHANGED=true
    GRAPHICS_MODE="$NEW_GRAPHICS"
    echo ""

    echo -e "${CYAN}┌─ FRM Quality Level Override (FFlag)${NC}"
    echo -e "${WHITE}│  Forces Roblox render quality. 1 = min (more FPS), 21 = max (more quality).${NC}"
    echo -e "${WHITE}│  Current: ${YELLOW}$( [ -n "$CUR_FRM" ] && echo "$CUR_FRM" || echo "disabled (FFlagExample placeholder)" )${NC}"
    echo -e "${WHITE}│  Optimized value: ${GREEN}1${NC}"
    if ask_yn "│  Enable FRM Quality Override?"; then
        FRM_ENABLED=true
        while true; do
            echo -e "${YELLOW}│  Enter value (1-21): ${NC}"
            read -p "  > " NEW_FRM
            if [[ "$NEW_FRM" =~ ^[0-9]+$ ]] && [ "$NEW_FRM" -ge 1 ] && [ "$NEW_FRM" -le 21 ]; then
                break
            else
                echo -e "${RED}  Invalid value. Enter a number between 1 and 21.${NC}"
            fi
        done
        [ "$NEW_FRM" != "$CUR_FRM" ] && CHANGED=true
        FRM_VALUE="$NEW_FRM"
    else
        FRM_ENABLED=false
        [ -n "$CUR_FRM" ] && CHANGED=true
    fi
    echo ""

    echo -e "${CYAN}┌─ Discord RPC${NC}"
    echo -e "${WHITE}│  Shows your Roblox activity on Discord status.${NC}"
    echo -e "${WHITE}│  Current: ${YELLOW}$CUR_DISCORD_RPC${NC}"
    echo -e "${WHITE}│  Optimized value: ${GREEN}true${NC}"
    if ask_yn "│  Enable Discord RPC?"; then
        NEW_DISCORD_RPC=true
        echo ""
        echo -e "${CYAN}┌─ Discord RPC Join Button${NC}"
        echo -e "${WHITE}│  Lets friends join your game directly from Discord.${NC}"
        echo -e "${WHITE}│  Current: ${YELLOW}$CUR_DISCORD_JOIN${NC}"
        echo -e "${WHITE}│  Optimized value: ${GREEN}true${NC}"
        if ask_yn "│  Show join button?"; then
            NEW_DISCORD_JOIN=true
        else
            NEW_DISCORD_JOIN=false
        fi
    else
        NEW_DISCORD_RPC=false
        NEW_DISCORD_JOIN=false
    fi
    [ "$NEW_DISCORD_RPC" != "$CUR_DISCORD_RPC" ] && CHANGED=true
    [ "$NEW_DISCORD_JOIN" != "$CUR_DISCORD_JOIN" ] && CHANGED=true
    DISCORD_RPC="$NEW_DISCORD_RPC"
    DISCORD_JOIN="$NEW_DISCORD_JOIN"
    echo ""

    echo -e "${CYAN}┌─ GameMode${NC}"
    echo -e "${WHITE}│  Prioritizes system resources for the game (Linux GameMode).${NC}"
    echo -e "${WHITE}│  Current: ${YELLOW}$CUR_GAMEMODE${NC}"
    echo -e "${WHITE}│  Optimized value: ${GREEN}true${NC}"
    if ask_yn "│  Enable GameMode?"; then
        NEW_GAMEMODE=true
    else
        NEW_GAMEMODE=false
    fi
    [ "$NEW_GAMEMODE" != "$CUR_GAMEMODE" ] && CHANGED=true
    GAMEMODE="$NEW_GAMEMODE"
    echo ""


    echo -e "${CYAN}┌─ Gamepad Support${NC}"
    echo -e "${WHITE}│  Enables controller/gamepad permission in Sober.${NC}"
    echo -e "${WHITE}│  Current: ${YELLOW}$CUR_GAMEPAD${NC}"
    echo -e "${WHITE}│  Optimized value: ${GREEN}false${NC} (enable only if you use a controller)"
    if ask_yn "│  Enable gamepad support?"; then
        NEW_GAMEPAD=true
    else
        NEW_GAMEPAD=false
    fi
    [ "$NEW_GAMEPAD" != "$CUR_GAMEPAD" ] && CHANGED=true
    GAMEPAD="$NEW_GAMEPAD"
    echo ""

   
    if ! $CHANGED; then
        echo -e "${GREEN}✔ No changes detected. Config is already up to date!${NC}\n"
        return
    fi

   
    print_field() {
        local label="$1" new="$2" cur="$3"
        if [ "$new" != "$cur" ]; then
            echo -e "${BLUE}║${NC}  $label : ${RED}$cur${NC} → ${GREEN}$new${NC}"
        else
            echo -e "${BLUE}║${NC}  $label : ${WHITE}$new${NC}"
        fi
    }

    echo -e "${BLUE}╔═════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${WHITE}                Summary                  ${BLUE}║${NC}"
    echo -e "${BLUE}╠═════════════════════════════════════════╣${NC}"
    print_field "Graphics mode  " "$GRAPHICS_MODE"   "$CUR_GRAPHICS"
    $FRM_ENABLED \
        && print_field "FRM Override   " "$FRM_VALUE"      "${CUR_FRM:-disabled}" \
        || echo -e "${BLUE}║${NC}  FRM Override   : ${WHITE}disabled${NC}"
    print_field "Discord RPC    " "$DISCORD_RPC"     "$CUR_DISCORD_RPC"
    print_field "Join Button    " "$DISCORD_JOIN"    "$CUR_DISCORD_JOIN"
    print_field "GameMode       " "$GAMEMODE"        "$CUR_GAMEMODE"
    print_field "Gamepad        " "$GAMEPAD"         "$CUR_GAMEPAD"
    echo -e "${BLUE}╚═════════════════════════════════════════╝${NC}\n"

    ask_yn "Save configuration?" || return

    
    if [ ! -d "$(dirname "$CONFIG_DEST")" ]; then
        echo -e "${YELLOW}Creating directory...${NC}"
        mkdir -p "$(dirname "$CONFIG_DEST")"
    fi

    if $FRM_ENABLED; then
        FFLAGS_BLOCK="\"fflags\": {
        \"DFIntDebugFRMQualityLevelOverride\": $FRM_VALUE
    }"
    else
        FFLAGS_BLOCK="\"fflags\": {
        \"FFlagExample\": true
    }"
    fi

    
    {
        echo "$CONFIG_HEADER"
        cat <<EOF
{
    "allow_gamepad_permission": $GAMEPAD,
    "close_on_leave": false,
    "discord_rpc_enabled": $DISCORD_RPC,
    "discord_rpc_show_join_button": $DISCORD_JOIN,
    "enable_gamemode": $GAMEMODE,
    "enable_hidpi": false,
    $FFLAGS_BLOCK,
    "graphics_optimization_mode": "$GRAPHICS_MODE",
    "server_location_indicator_enabled": false,
    "touch_mode": "off",
    "use_console_experience": false,
    "use_libsecret": false,
    "use_opengl": false
}
EOF
    } > "$CONFIG_DEST"

    echo -e "\n${GREEN}✔ Configuration saved successfully to:${NC}"
    echo -e "${WHITE}  $CONFIG_DEST${NC}\n"
}

while true; do
    clear
    print_banner
    echo -e "${BLUE}╔═════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${WHITE}        Sober Optimizer Installer        ${BLUE}║${NC}"
    echo -e "${BLUE}╠═════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║  ${GREEN}1)${WHITE} Configure and apply optimizations    ${BLUE}║${NC}"
    echo -e "${BLUE}║  ${RED}2)${WHITE} Exit                                 ${BLUE}║${NC}"
    echo -e "${BLUE}╚═════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}"
    read -p "  Select an option: " option
    echo -e "${NC}"

    case $option in
        1)
            configure_sober
            read -p "$(echo -e ${YELLOW})Press Enter to continue...$(echo -e ${NC})"
            ;;
        2)
            echo -e "${RED}Exiting.${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            read -p "$(echo -e ${YELLOW})Press Enter to continue...$(echo -e ${NC})"
            ;;
    esac
done