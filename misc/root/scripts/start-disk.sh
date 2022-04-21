#/bin/bash

FS=$1
DISK=/dev/sda3
MNT=/mnt
MFLAGS=""

if [[ "$FS" != "ext4-ordered" ]] && [[ "$FS" != "nilfs2" ]] && [[ "$FS" != "ext4-journal" ]] && [[ "$FS" != "ext4-writeback" ]] && [[ "$FS" != "ntfs" ]]; then
	echo "Run as: ./start-disk.sh ext4-ordered/ext4-journal/ext4-writeback/nilfs2/ntfs"
	exit 1
fi

if [[ $(mount | grep $DISK) ]]; then
	echo "Disk $DISK already mounted. Run ./stop-disk.sh first."
	exit 1
fi

# Create filesystem
if [[ "$FS" == "ext4-ordered" ]]; then
	FLAGS=-F
	FS=ext4
	MFLAGS=-odata=ordered
elif [[ "$FS" == "ext4-journal" ]]; then
	FLAGS=-F
	FS=ext4
	MFLAGS=-odata=journal
elif [[ "$FS" == "ext4-writeback" ]]; then
        FLAGS=-F
        FS=ext4
        MFLAGS=-odata=writeback
elif [[ "$FS" == "ntfs" ]]; then
	FLAGS="-F -f"
else
	FLAGS=-f
fi

mkfs.$FS $FLAGS $DISK && echo "Created filesystem $FS on disk $DISK"

# Mount filesystem
mount $DISK $MNT $MFLAGS && echo "Mounted $DISK at $MNT"
exit 0



