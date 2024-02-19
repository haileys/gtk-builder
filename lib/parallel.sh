declare -g PARALLEL
declare -g parallel_view_pipe
declare -g -a task_pids

parallel::init() {
    PARALLEL=1

    # open a pipe fd to the render subshell
    exec {parallel_view_pipe}> >(parallel::view::main)
}

task::spawn() {
    local task_name="$1"
    [[ "${2:-}" == "--" ]] || die "internal error: usage: parallel::spawn <label> -- <command...>"
    shift 2

    # spawn task in subshell and capture pid
    parallel::view::send new "$task_name"
    ( "$@" ) &
    local pid="$!"
    task_pids+=("$pid")
}

task::status() {
    [ -n "${task_name:-}" ] || return 0
    [ -n "$PARALLEL" ] || return 0
    parallel::view::send status "$task_name" "$1"
}

task::started() {
    [ -n "${task_name:-}" ] || die "can only call task::fail from within parallel task"
    [ -n "$PARALLEL" ] || return 0
    parallel::view::send started "$task_name"
}

task::finished() {
    [ -n "${task_name:-}" ] || die "can only call task::finished from within parallel task"
    [ -n "$PARALLEL" ] || return 0
    parallel::view::send finished "$task_name"
    parallel::view::send status "$task_name" "$1"
}

task::error() {
    [ -n "${task_name:-}" ] || return 0
    [ -n "$PARALLEL" ] || return 0
    parallel::view::send failed "$task_name"
    parallel::view::send status "$task_name" "$1"
}

parallel::await() {
    while [ "${#task_pids[@]}" -gt 0 ]; do
        local exited_pid
        wait -n -p exited_pid "${task_pids[@]}" || true

        # rebuild task_pids array without the pid that just finished
        declare -a old_task_pids=("${task_pids[@]}")
        task_pids=()
        for pid in "${old_task_pids[@]}"; do
            [ "$pid" -ne "$exited_pid" ] && task_pids+=("$pid")
        done
    done
}

parallel::view::send() {
    local quoted=""
    local arg
    for arg in "$@"; do
        quoted+=" ${arg@Q}"
    done
    echo "$quoted" >&$parallel_view_pipe
}

parallel::view::main() {
    declare -a tasks
    declare -A task_state
    declare -A task_status

    local last_task_count=0

    local message_raw
    while read -r message_raw; do
        declare -a message

        # message args are already quoted by send-side
        eval "message=($message_raw)"

        # echo "Msg:" "${message[@]}"
        # continue

        # first, handle whatever message we just received
        local command="${message[0]:-}"
        local task="${message[1]:-}"

        case "$command" in
        new)

            tasks+=("$task")
            task_status["$task"]=""
            task_state["$task"]=""
            ;;
        started)
            task_state["$task"]=started
            ;;
        finished)
            task_state["$task"]=finished
            ;;
        failed)
            task_state["$task"]=failed
            ;;
        status)
            local task="${message[1]:-}"
            local status="${message[2]:-}"

            task_status["$task"]="$status"
            ;;
        esac

        # then render out the tasks view
        if [ "$last_task_count" -gt 0 ]; then
            # move up lines to re-render
            echo -en "\e[${last_task_count}A"
            true
        fi

        local task
        for task in "${tasks[@]}"; do
            # first kill current line
            echo -en "\e[0K"

            # styles for task output
            local label_style status_style
            case "${task_state["$task"]}" in
            "")
                label_style="34"
                status_style="2" ;;
            started)
                label_style="34;1"
                status_style="" ;;
            finished)
                label_style="32;1"
                status_style="32" ;;
            failed)
                label_style="31;1"
                status_style="31" ;;
            esac

            # print styled task line
            printf "\e[${label_style}m%16s\e[0m  \e[${status_style}m%s\e[0m\n" "$task" "${task_status["$task"]}"
        done

        last_task_count="${#tasks[@]}"
    done
}
