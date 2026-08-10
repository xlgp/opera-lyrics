#!/usr/bin/env bash

set -u

ALL_LRC_NAME="all.lrc"

generate_name_list() {
    find . -type f -name "*.lrc" ! -name "${ALL_LRC_NAME}" -print > name.list
}

add_new_line() {
    local tmp_file_name="tmp.lrc"
    sed '10,$s/\[ti/\n[ti/g' "${ALL_LRC_NAME}" > "${tmp_file_name}" && \
        mv "${tmp_file_name}" "${ALL_LRC_NAME}"
}

generate_all_lrc() {
    : > "${ALL_LRC_NAME}"
    find . -path "./.git" -prune -o -type f -name "*.lrc" ! -name "${ALL_LRC_NAME}" -exec cat {} + >> "${ALL_LRC_NAME}"
    add_new_line
}

generate_new_name_list() {
    ls -l -R --full-time --time-style=long-iso -G -g > full-name.list
}

print_summary() {
    echo "${ALL_LRC_NAME} 数据:"
    grep -c '^$' "${ALL_LRC_NAME}"
    echo "name.list 数据"
    wc -l name.list
}

print_end() {
    echo "删除多余的空行, 执行替换"
    echo "查找：^\n$"
    echo "替换为空"
}

fetch_push() {
    local origin
    for origin in $(git remote); do
        echo -e "\nfetch from \e[33m${origin}\e[0m"
        git fetch "${origin}"
        echo -e "push to \e[33m${origin}\e[0m"
        git push "${origin}"
    done
}

generate_lists() {
    echo "生成旧版唱段目录"
    generate_name_list
    echo "生成唱段目录"
    generate_new_name_list
}

all() {
    echo "生成唱段总列表"
    generate_all_lrc
}

fp() {
    fetch_push
}

fetch_all_remotes() {
    local origin
    for origin in $(git remote); do
        git fetch "${origin}"
    done
}

f() {
    fetch_all_remotes
}

generate_git_log() {
    # 生成最近 6 个月的唱段新增和更新日志
    git log --grep="^唱段：\(新增\|更新\)" --name-status --stat --since="6 months ago" -- "*.lrc" | grep -v "all.lrc" > commit.log
}

log() {
    generate_git_log
}

show_help() {
    echo "  all   generate_all_lrc"
    echo "  gl    generate_lists"
    echo "  fp    fetch_push"
    echo "  log   generate_git_log"
    echo "  h     show help"
}

h() {
    show_help
}

gl() {
    generate_lists
}

main() {
    local action="${1:-h}"

    case "${action}" in
        all|gl|fp|f|log|h|generate_all_lrc|generate_name_list|generate_new_name_list|generate_lists|generate_git_log|fetch_all_remotes|fetch_push|show_help)
            "${action}"
            ;;
        "")
            h
            ;;
        *)
            echo "未知命令: ${action}"
            show_help
            return 1
            ;;
    esac
}

main "$@"
