# Pacman hook which makes btrfs root snapshot before any action.
***
### Description: 
This is a written on bash script and Pacman hook which makes btrfs root snapshot before any action. **Requires Archlinux-based OS (pacman) and `btrfs-tools` to be installed.**

Feature is one and simple:
* Hook will detect if your root filesystem is btrfs subvolume. If yes, it'll make snapshot of it.
### Usage: 
```
Just install and profit!
