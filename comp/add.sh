. ../library/snip_path.env

sed -i -e '$d' -e '$d' $snip_path
../library/snip $@ >> $snip_path
echo "}" >> $snip_path