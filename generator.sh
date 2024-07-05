#!/bin/bash

ALL_LRC_NAME=all.lrc

#生成唱段名列表
generateNameList() {
    echo "生成唱段名列表"
    find . -type f -name "*.lrc" |grep -v ${ALL_LRC_NAME} > name.list
}

#添加换行
addNewLine(){
    sed -i '10,$s/\[ti/\n[ti/g' ${ALL_LRC_NAME}
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
        git fetch ${origin}
        git push ${origin}
    done
}
 gl(){
    generateNameList
    generateNewNameList
 }

 all(){
    generateAllLrc
 }

 fp(){
    fetchPush
 }
 $1