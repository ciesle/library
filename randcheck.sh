#!/bin/bash
rand_path="./.vscode/auto_randcheck"
gen_path="gen.cpp"
main_path="main.cpp"
brute_path="brute.cpp"
input_path="rnd_in.txt"
output_main_path="rnd_outm.txt"
output_brute_path="rnd_outb.txt"

function clean_up(){
    if [ $? -eq 0 ]; then
        printf "random check \e[32;1mcompleted!!\e[m\n" 1>&2
        rm $input_path $output_brute_path $output_main_path
        if [ -e ./gen ]; then rm ${gen_path%%.cpp}; fi
        if [ -e ./brute ]; then rm ${brute_path%%.cpp}; fi
    fi
}

function fail_output {
    if [ $1 -ne 0 ] ; then
        printf "$2 \e[31;1mfailed\e[m\n" 1>&2
        cp $rand_path/${gen_path%%.cpp} ./${gen_path%%.cpp}
        cp $rand_path/${brute_path%%.cpp} ./${brute_path%%.cpp}
        exit 1
    fi
}

function check_hash(){
    local pre_hash=()
    local files=($gen_path $main_path $brute_path)
    local new_hash=()
    if [ -s "$rand_path/hist" ]; then pre_hash=($(cat $rand_path/hist | xargs)); fi
    for i in "${!files[@]}"; do
        local current_hash=$(md5sum ${files[$i]} | cut -d" " -f1)
        if [ ${#pre_hash[@]} -le $i ] || [ "${pre_hash[$i]}" != "${current_hash}" ]; then
            g++ -O2 ${files[$i]} -o $rand_path\/${files[$i]%%.cpp}
            if [ $? -ne 0 ]; then exit 1; fi
            echo "compiled ${files[$i]%%.cpp}" 1>&2
        fi
        new_hash+=($current_hash)
    done
    printf "%s\n%s\n%s" "${new_hash[@]}" > "$rand_path/hist"
}

trap clean_up EXIT

check_hash
cp $rand_path/${main_path%%.cpp} ./${main_path%%.cpp}

options=""
num=100
while (( $# > 0 )) ; do
    case $1 in
        "-o")
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "option error" 1>&2
                exit 1
            else
                num=$2
            fi
            shift
            ;;
        *)
            if [[ -z options ]]; then
                options=$1
            else
                options=$options" "$1
            fi;;
        esac
    shift
done
for ((i = 1 ; i <= $num ; i++)) ; do
    $rand_path/${gen_path%%.cpp} $options > "$input_path"
    fail_output $? "generate"
    $rand_path/${main_path%%.cpp} < "$input_path" > "$output_main_path"
    fail_output $? "${main_path%%.cpp} run"
    $rand_path/${brute_path%%.cpp} < "$input_path" > "$output_brute_path"
    fail_output $? "${brute_path%%.cpp} run"
    if [ "$(cat $output_main_path)" != "$(cat $output_brute_path)" ] ; then
        printf "\e[31;1mcheck failed\e[m\n" 1>&2
        printf "in\n%s\n${main_path%%.cpp}\n%s\n${brute_path%%.cpp}\n%s\n" "`cat $input_path`" "`cat $output_main_path`" "`cat $output_brute_path`"
        cp $rand_path/${gen_path%%.cpp} ./${gen_path%%.cpp}
        cp $rand_path/${brute_path%%.cpp} ./${brute_path%%.cpp}
        exit 1
    fi
    if [ $(($i % 100)) -eq 0 ] ; then
        echo "$i case finished!" 1>&2
    fi
done
