# Bash script with Pacman hook which help make btrfs root snapshots fast, simple and automatically.
***
### Description: 
This is a written on bash script with Pacman hook which help make btrfs root snapshots fast and simple. If your OS is Archlinux-based, Pacman hook will make snapshots before any change 

### Current features:
* Hook will detect if your root filesystem is btrfs subvolume. If yes, it'll make snapshot of it.
* Also you can manage snapshots: list and delete old ones. Use -h or --help key.
* Script will work even if your root is LUKS container.
### Requirements:
`btrfs-progs`
`util-linux`
`coreutils`

Also Archlinux-based OS for pacman hook.
### Installing: 
```
# git clone https://github.com/vvl-rulez/btrfs-autosnap.git
# cd btrfs-autosnap/
# sudo install -Dm644 btrfs-autosnap.conf /etc/btrfs-autosnap.conf
# sudo install -Dm755 btrfs-autosnap.sh /usr/bin/btrfs-autosnap
```
If your OS is Archlinux-based, you can also install pacman hook:
```
# sudo cp 01-btrfs-autosnap.hook /usr/share/libalpm/hooks/01-btrfs-autosnap.hook
```
Profit!
P.S. You can install it by [AUR package](https://aur.archlinux.org/packages/btrfs-autosnap/).
### Usage: 
```
btrfs-autosnap [parameter] (only first parameter will be used!)
Available commands:
    -l,  --list           list existing snapshots with modify time,
    -r,  --remove-old     remove old snapshots with config parameter,
    -h,  --help           show this help and exit.
    -v,  --version        show version information.
If there are no parameter, btrfs-autosnap will delete old snapshots if necessary and make new one."
```
