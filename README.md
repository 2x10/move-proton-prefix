# move-proton-prefix
creates a link from a Steam game's compability data that is installed on a NTFS drive to a EXT4 drive so proton and similar tools from Steam can run properly on Linux.


### Example usage:
``./proton-prefix-mover.sh --gameid 123456 --library nvme01``

You can configure 4 different libraries in the script
```
nvme01="/mnt/ntfs/drive_a/Steam/steamapps"
nvme02="/mnt/ntfs/drive_b"
hdd01="/mnt/ntfs/drive_c"
hdd02="/mnt/ntfs/drive_d"
```