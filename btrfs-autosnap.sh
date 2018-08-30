#!/bin/bash
if [[ $EUID -ne 0 ]]; then sudo $0 $@ || su -c $0 $@ || exit 1; exit 0; fi
source /etc/btrfs-autosnap.conf 2>/dev/null
if [[ $(findmnt -n / | awk '{print $3}') != "btrfs" ]]; then echo -e "\033[1;31mRoot filesystem is not btrfs! exiting...\033[0m" && exit 1; fi
subvol=$(findmnt -n / | awk '{print $4}' | grep -o subvol=/.* | sed 's/subvol=\///')
if [[ -z ${subvol} ]]; then echo -e "\033[1;31mRoot filesystem is not subvolume! exiting...\033[0m" && exit 1; fi
prepare() {
mkdir -p /tmp/subvol
mount $(findmnt -vn / | awk '{print $2}') /tmp/subvol
cd /tmp/subvol
}
clean() {
cd /tmp
umount /tmp/subvol &>/dev/null
}
snap_delete() {
for sub in $(find . -maxdepth 1 -type d -name "${subvol}-*" -printf "%T@ %f\n" | sort -nr | tail +$(($old+1)) | cut -d ' ' -f 2)
do
btrfs su delete $sub &>/dev/null && echo -e "\033[1;34mDeleted old snapshot $sub\033[0m" || echo -e "\033[1;31mError while deleting old snapshot $sub!\033[0m"
done
if [[ -z "$sub" ]]; then echo -e "\033[1;34mThere are no old snapshots to be deleted!\033[0m"; fi
}
snap_make() {
new=$(</dev/urandom tr -dc "a-z0-9" 2>/dev/null | head -c6)
touch ${subvol}
btrfs su snapshot ${subvol} ${subvol}-$new &>/dev/null && echo -e "\033[1;32mCreated snapshot ${subvol}-$new!\033[0m" || echo -e "\033[1;31mError while creating snapshot ${subvol}-$new!\033[0m"
}
snap_list() {
find . -maxdepth 1 -type d -name "${subvol}-*" -printf "%f\t%TY-%Tm-%Td %TH:%TM:%.2TS\n" | sort -rk2
}
snap_help() {
echo "Usage: btrfs-autosnap [parameter] (only first parameter will be used!)
Available commands:
    -l,  --list           list existing snapshots with modify time,
    -r,  --remove-old     remove old snapshots with config parameter,
    -h,  --help           show this help and exit.
    -v,  --version        show version information.
If there are no parameter, btrfs-autosnap will delete old snapshots if necessary and make new one."
}
snap_version() {
echo "btrfs-autosnap by VVL
version 1.0.1     30 august 2018"
}
case "${1}" in
    -l|--list) prepare && snap_list && clean ;;
    -r|--remove-old) prepare && snap_delete && clean ;;
    -h|--help) snap_help ;;
    -v|--version) snap_version ;;
    *) prepare && snap_delete && snap_make && clean ;;
esac
