#compdef deploy

function _deploy {
    local context state state_desc line

    # get command name and already typed in arguments
    local cmd="${(@)words[1]}"
    local args="${(@)words:1}"

    _arguments -s \
        "(- :)-h[show help]" \
        "(-h)-v[be verbose]" \
        "(-h)-w[show warnings]" \
        "(-h -l)-D[dry run]" \
        "(-h -d -t -s -u -n -a -i -L)-l[list targets]" \
        "(-h -d -t -s -u -n -a -i -l)-L[list targets without project information]" \
        "(-d -h -l)-t+[target]:target:->targets" \
        "(-t -h -l)-d[use default target]" \
        "-p+[project directory]:directory:_directories" \
        "(-h)-c+[configuration file]:file:_files" \
        "(-s -u -n)-a[deploy all files]" \
        "(-a)-s[deploy staged files]" \
        "(-a)-u[deploy unstaged files]" \
        "(-a)-n[deploy untracked files]" \
        "-I[deploy ignored files]" \
        "*::file:->files" 

    case "$state" in
        files)
            # completion for deployable files
            local ldir cwd prefix root
            ldir=$(eval "$cmd -IL $args" 2> /dev/null)
            cwd=$(pwd)
            if [ $ldir ]; then
                if [[ "${cwd##$ldir}" != "${cwd}" ]]; then
                    # if the cwd is inside the project directory use paths relative to the cwd
                    prefix=""
                    root="$cwd"
                elif [[ "${ldir##$cwd}" != "${ldir}" ]]; then
                    # if the cwd is in the rootline of the project directory use a relative path
                    prefix="$(realpath --relative-to=$cwd $ldir)/"
                    root="$ldir"
                else
                    # if the cwd is somewhere else use an absolute path
                    prefix="$(realpath $ldir)/"
                    root="$ldir"
                fi
                _path_files -f -W "$root" -P "$prefix" && _ret=0
            fi
            ;;
        targets)
            # completion for avaible targets
            local -a list targets
            targets=$(eval "$cmd -Lv $args 2> /dev/null")
            targets=("${(f)targets}")
            for target in $targets; do
                local key="$(echo $target | awk '{print $1}')"
                local value="$(echo $target | awk '{$1=""; print $0}' | sed 's/:/\\:/g')"
            list+=("$key:$value")
            done
            _describe 'targets' list && _ret=0
            ;;
    esac
}

_deploy "$@"
