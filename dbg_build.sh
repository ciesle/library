#!/bin/bash
out_path="./.vscode/auto_build"
main_path="main.cpp"

echo -e "\e[35;1mdebug build $main_path\e[m"

make ${out_path}/${main_path%%.cpp}_dbg
if [ $? -ne 0 ]; then
    printf "build \e[31;1mfailed\e[m\n"
    exit 1
fi
printf "build \e[32;1mcompleted!\e[m\n"
