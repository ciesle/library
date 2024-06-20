#!/usr/bin/bash

if [ $# -ne 1 ];then
	echo "Usage: $0 dir_name"
	exit 1
fi

ln Makefile ../$1/Makefile
mkdir -p ../$1/.vscode/
mkdir -p ../$1/.vscode/auto_build
{
	name=$(cd $(dirname $0) && pwd)
	name=${name##*/}
	$(cd ../$1 && ln -s ../$name/comp/ library/)
	rm -f ../$1/library/comp
}

files=("gdb_exit.sh" "launch.json" "randcheck.sh" "c_cpp_properties.json" "dbg_build.sh" "opt_build.sh" "settings.json" "tasks.json")
for file in ${files[@]};do
	ln $file ../$1/.vscode/$file
done

cat keybindings.json.bk > /mnt/c/Users/thistle/AppData/Roaming/Code/User/keybindings.json
touch ../$1/main.cpp ../$1/gen.cpp ../$1/brute.cpp ../$1/in.txt
