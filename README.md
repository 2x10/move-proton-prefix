# move-proton-prefix
Creates a link from a Steam game's compability data that is installed on a NTFS drive to a EXT4 drive so proton and similar tools from Steam can run properly on Linux.

This tool is aimed towards people who may be in a similar situation like me, i dual boot Winddows 11 and arch linux, though my disk space of my arch install is kinda small (only 128gb) and i have all of my games on other drives which are ntfs disks. Now unfortunately, games that run may run natively on linux or run via Steam's proton compatability tool don't run on ntfs drives, due to the x attribute to execute scripts and binaries simply being non-existent on the NTFS partition scheme. Now instead of installing the whole game on a ext4 drive, you can just move the compat data to a ext4 drive and leave the other game files on your ntfs drive. 

To look up the appid of games, simply run Steam in the terminal and run the game that doesn't work. It'll then show some error alongside the actual path of the game, which is something along the lines of .../Steam/steamapps/compatdata/43534252/...

That random number is the appid that you need to use.

### Example usage:
``./proton-prefix-mover.sh --appid 123456 --library nvme01``

You can configure 4 different libraries in the script
```
nvme01="/mnt/ntfs/drive_a/Steam/steamapps/compatdata"
nvme02="/mnt/ntfs/drive_b/Steam/steamapps/compatdata"
hdd01="/mnt/ntfs/drive_c/Steam/steamapps/compatdata"
hdd02="/mnt/ntfs/drive_d/Steam/steamapps/compatdata"
```