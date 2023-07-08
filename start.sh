# an script to start qemu with kernel and rootfs
# copy kernel and busybox to current directory
cp /home/smark/code/c/linux/arch/x86_64/boot/bzImage ./
cp /home/smark/code/c/busybox-1.36.1/busybox ./

# create rootfs directory
mkdir rootfs
    cd rootfs
    mkdir bin dev etc home lib proc sbin sys tmp usr var
    cd bin
        cp ../../busybox ./
        for prog in $(./busybox --list); do 
            ln -s /bin/busybox $prog; 
        done
    cd ..
    echo '#!/bin/sh' >> init
    echo 'mount -t sysfs sysfs /sys' >> init
    echo 'mount -t proc proc /proc' >> init
    echo 'mount -t devtmpfs udev /dev' >> init
    echo 'sysctl -w kernel.printk="4 4 1 7"' >> init
    echo '/bin/sh' >> init
    echo 'poweroff -f' >> init
    chmod -R 777 .
    find . | cpio -o -H newc > ../rootfs.img
cd ..

# run qemu
qemu-system-x86_64 -kernel bzImage -initrd rootfs.img


