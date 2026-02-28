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
autoload -Uz .zem_current
autoload -Uz .zem_i18n_load .zem_config

# === 4. Register completion ===
compdef _zem zem

# === 5. Initialize language and auto-load default profile(s) ===
() {
    # Load language setting and initialize i18n messages
    local lang=$(.zem_config_get language)
    export ZEM_LANGUAGE="${lang:-en}"
    .zem_i18n_load

    # If already set (e.g. by a parent shell), don't override loaded profiles
    [[ -n $ZEM_LOADED_PROFILES ]] && return

    local default_profiles=$(.zem_config_get default_profile)

    if [[ -n $default_profiles ]]; then
        local profile_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zem/profiles"
        local p
        local -a auto_loaded
        for p in ${(s: :)default_profiles}; do
            local profile_file="$profile_dir/$p"
            if [[ -f $profile_file ]] && source "$profile_file" 2>/dev/null; then
                auto_loaded+=("$p")
            fi
        done
        if (( ${#auto_loaded} > 0 )); then
            export ZEM_LOADED_PROFILES="${auto_loaded[*]}"
        fi
    fi
}

# === 6. Unload function ===
zem_plugin_unload() {
    unfunction zem 2>/dev/null
    unfunction .zem_add .zem_load .zem_unload .zem_list .zem_rm 2>/dev/null
    unfunction .zem_edit .zem_show .zem_export .zem_import 2>/dev/null
    unfunction .zem_init .zem_help 2>/dev/null
    unfunction .zem_config_get .zem_config_set .zem_default 2>/dev/null
    unfunction .zem_validate_profile_name .zem_current 2>/dev/null
    unfunction .zem_i18n_load .zem_config 2>/dev/null
    unfunction _zem 2>/dev/null
    unset ZEM_LANGUAGE ZEM_MSGS 2>/dev/null
    unfunction zem_plugin_unload 2>/dev/null
}
