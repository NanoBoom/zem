# zem.plugin.zsh
# Environment Profile Manager for Zsh
# https://github.com/NanoBoom/zem

# === 1. Standardized $0 handling ===
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# === 2. Handle functions/ directory ===
if [[ $PMSPEC != *f* ]]; then
    fpath+=( "${0:h}/functions" )
fi

# === 3. Autoload functions ===
autoload -Uz zem
autoload -Uz .zem_add .zem_load .zem_unload .zem_list .zem_rm
autoload -Uz .zem_edit .zem_show .zem_export .zem_import
autoload -Uz .zem_init .zem_help
autoload -Uz .zem_config_get .zem_config_set .zem_default
autoload -Uz .zem_validate_profile_name

# === 4. Register completion ===
compdef _zem zem

# === 5. Auto-load default profile ===
() {
    local default_profile=$(.zem_config_get default_profile)

    if [[ -n $default_profile ]]; then
        local profile_file="${XDG_CONFIG_HOME:-$HOME/.config}/zem/profiles/$default_profile"
        # Silently load if profile exists
        [[ -f $profile_file ]] && source "$profile_file" 2>/dev/null
    fi
}

# === 6. Unload function ===
zem_plugin_unload() {
    unfunction zem 2>/dev/null
    unfunction .zem_add .zem_load .zem_unload .zem_list .zem_rm 2>/dev/null
    unfunction .zem_edit .zem_show .zem_export .zem_import 2>/dev/null
    unfunction .zem_init .zem_help 2>/dev/null
    unfunction .zem_config_get .zem_config_set .zem_default 2>/dev/null
    unfunction .zem_validate_profile_name 2>/dev/null
    unfunction _zem 2>/dev/null
    unfunction zem_plugin_unload 2>/dev/null
}
