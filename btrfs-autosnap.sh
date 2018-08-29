#!/bin/bash
if [[ $(findmnt -n / | awk '{print $3}') != "btrfs" ]]
then
echo -e "\033[1;31mRoot filesystem is not btrfs! exiting...\033[0m"
exit 1
fi
subvol=$(findmnt -n / | awk '{print $4}' | grep -o subvol=/.* | sed 's/subvol=\///')
if [[ -z ${subvol} ]]
then
echo -e "\033[1;31mRoot filesystem is not subvolume! exiting...\033[0m"
exit 1
fi
mkdir -p /tmp/subvol
mount $(findmnt -vn / | awk '{print $2}') /tmp/subvol
cd /tmp/subvol
for sub in $(find . -maxdepth 1 -type d -name "${subvol}-*" -printf "%T@ %f\n" | sort -nr | tail +2 | cut -d ' ' -f 2)
do
btrfs su delete $sub || echo -e "\033[1;31mError while deleting $sub!\033[0m"
done
btrfs su snapshot ${subvol} ${subvol}-$(date +\%d.\%m.\%y) && echo -e "\033[1;32mCreated snapshot ${subvol}-$(date +\%d.\%m.\%y)!\033[0m" || echo -e "\033[1;31mError while creating snapshot ${subvol}-$(date +\%d.\%m.\%y)!\033[0m"
umount /tmp/subvol
