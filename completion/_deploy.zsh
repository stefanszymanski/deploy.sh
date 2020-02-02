#compdef deploy

function _deploy {
    _arguments -c \
        "(- :)-h[show help]" \
        "(-h)-v[be verbose]" \
        "(-h)-w[show warnings]" \
        "(-h -d -t -s -u -n -a -i)-l[list targets]" \
        "(-d -h -l)-t[target]: :_deploy_targets" \
        "(-t -h -l)-d[use default target]" \
        "-p[project directory]: :_directories" \
        "-c[configuration file]: :_files" \
        "(-s -u -n)-a[deploy all files]" \
        "(-a)-s[deploy staged files]" \
        "(-a)-u[deploy unstaged files]" \
        "(-a)-n[deploy untracked files]" \
        "-i[deploy ignored files]" \
        "(-)*::arg:->arg"
}

function _deploy_targets {
    local -a list
    local targets=("${(f)$(deploy -Lv 2>/dev/null)}")
    for target in $targets; do
        local key="$(echo $target | awk '{print $1}')"
        local value="$(echo $target | awk '{$1=""; print $0}' | sed 's/:/\\:/g')"
    list+=("$key:$value")
    done
    _describe 'targets' list && _ret=0
}

_deploy "$@"
