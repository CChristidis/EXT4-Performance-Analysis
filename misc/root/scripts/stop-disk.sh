#/bin/bash

DISK=/dev/sda3
MNT=/mnt

if ! [[ $(mount | grep $DISK) ]]; then
	echo "Disk $DISK not mounted."
	exit 1
fi

# Unmount disk
umount $DISK && echo "Disk $DISK unmounted."
exit 0
