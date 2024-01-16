
# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases' ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob' ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh -o extended_glob

    # Unset all configuration options.
    unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

    [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        context
        dir
        vcs
        command_execution_time
        rust_version
        node_version
        virtualenv
        prompt_char
    )
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

    typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
    typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='⬢'
    typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=green
    typeset -g POWERLEVEL9K_NODE_VERSION_PREFIX='%fvia '

    # Rust
    typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=1
    typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='🦀'
    typeset -g POWERLEVEL9K_RUST_VERSION_PREFIX='%fvia '

    # Basic style options that define the overall prompt look.
    typeset -g POWERLEVEL9K_BACKGROUND=
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=

    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=green
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=red
    typeset -g POWERLEVEL9K_PROMPT_CHAR_CONTENT_EXPANSION='%B➜'

    typeset -g POWERLEVEL9K_DIR_FOREGROUND=cyan
    # Show only the last segment of the current directory.
    typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
    # Bold directory.
    typeset -g POWERLEVEL9K_DIR_CONTENT_EXPANSION='%B$P9K_CONTENT'
    typeset -g POWERLEVEL9K_DIR_PREFIX='%fin '
    typeset -g POWERLEVEL9K_VCS_PREFIX='%255F%B➜ '

    # Context
    typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n'
    # typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n at %m'

    function git_dirty_status() {
        ((
                VCS_STATUS_NUM_UNSTAGED > 0 ||
                VCS_STATUS_NUM_STAGED_DELETED > 0 ||
                VCS_STATUS_NUM_UNSTAGED_DELETED > 0 ||
                VCS_STATUS_HAS_UNTRACKED ||
                VCS_STATUS_HAS_STAGED
        ));
    }

    # Git status formatter.
    function my_git_formatter() {
        emulate -L zsh
        if [[ -n $P9K_CONTENT ]]; then
            # If P9K_CONTENT is not empty, it's either "loading" or from vcs_info (not from
            # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
            typeset -g my_git_format=$P9K_CONTENT
        else
            # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh
            typeset -g my_git_format="${1+%B%4F}${1+%5F} "
            my_git_format+=${${VCS_STATUS_LOCAL_BRANCH:-${VCS_STATUS_COMMIT[1,8]}}//\%/%%}
            if git_dirty_status; then
                my_git_format+=" ${1+%1F[}"
                # TODO: Figure out what everything means
                (( VCS_STATUS_NUM_STAGED_DELETED > 0 || VCS_STATUS_NUM_UNSTAGED_DELETED > 0 )) && my_git_format+="✘"
                (( VCS_STATUS_NUM_UNSTAGED )) && my_git_format+="!"
                (( VCS_STATUS_HAS_STAGED )) && my_git_format+="+"

                if [[ $VCS_STATUS_COMMITS_AHEAD > 0 && $VCS_STATUS_COMMITS_BEHIND > 0 ]]; then
                    my_git_format+="⇕"
                elif [[ $VCS_STATUS_COMMITS_AHEAD > 0 ]]; then
                    my_git_format+="⇡"
                elif [[ $VCS_STATUS_COMMITS_BEHIND > 0 ]]; then
                    my_git_format+="⇣"
                fi

                (( VCS_STATUS_STASHES )) && my_git_format+="$"

                # Renamed files
                (( VCS_STATUS_NUM_STAGED_NEW && VCS_STATUS_NUM_STAGED_DELETED )) && my_git_format+="»"

                (( VCS_STATUS_HAS_UNTRACKED )) && my_git_format+="?"

                my_git_format+="]"
            fi
        fi
    }
    functions -M my_git_formatter 2>/dev/null

    # Disable the default Git status formatting.
    typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
    # Install our own Git status formatter.
    typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
    typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}'
    # Grey Git status when loading.
    typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=246
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

    # If p10k is already loaded, reload configuration.
    # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
    (( ! $+functions[p10k] )) || p10k reload
}

((${#p10k_config_opts})) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
