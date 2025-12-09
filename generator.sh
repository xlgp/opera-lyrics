#!/bin/bash

ALL_LRC_NAME=all.lrc

#生成唱段名列表
generateNameList() {
    find . -type f -name "*.lrc" |grep -v ${ALL_LRC_NAME} > name.list
}

#添加换行
addNewLine(){
	TMP_FILE_NAME=tmp.lrc
    sed '10,$s/\[ti/\n[ti/g' ${ALL_LRC_NAME} > ${TMP_FILE_NAME} && mv ${TMP_FILE_NAME} ${ALL_LRC_NAME}
}

generateAllLrc(){
    :> ${ALL_LRC_NAME}
    for name in `find ./ -path "./.git" -prune -o  -type d ! -name "."|grep -v ".git"`
    do
        cat ${name}/*.lrc >> ${ALL_LRC_NAME}
    done
    addNewLine
}

generateNewNameList(){
    ls -l -R --full-time --time-style=long-iso -G -g > full-name.list
}

print(){
    echo ${ALL_LRC_NAME}"数据:"
    grep ^$ ${ALL_LRC_NAME}|wc
    echo "name.list 数据"
    wc name.list
}

printEnd(){
    echo "删除多余的空行,执行替换"
    echo "查找：^\n$"
    echo "替换为空"
}

fetchPush(){
    for origin in `git remote`
    do
        echo -e "\\nfetch from \e[33m"${origin}"\e[0m"
        git fetch ${origin}
        echo -e "push to \e[33m"${origin}"\e[0m"
        git push ${origin}
    done
}

 gl(){
    echo "生成旧版唱段目录"
    generateNameList
    echo "生成唱段目录"
    generateNewNameList
 }

 all(){
    echo "生成唱段总列表"
    generateAllLrc
 }

 fp(){
    fetchPush
 }

fetch(){
    for origin in `git remote`
    do
        git fetch ${origin}
    done
}
 f(){
    fetch
}

help(){
    echo "  all   generateAllLrc"
    echo "  gl    generateNameList and generateNewNameList"
    echo "  fp    fetchPush"
    echo "  h     show help info"
}

h(){
    help
}

 $1
