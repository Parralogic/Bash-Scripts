#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 11/01/2020
#Last Modified: 11/01/2020
clear

read -p "This script will guide you to install Arch-Linux: Press ANY key to continue WARNING STILL IN THE WORKS"
clear
echo "First lets select your keyboard layout, only worry about the NAME minus the extension of '.map.gz'"
echo "So if your keyboard layout is in /usr/share/kbd/keymaps/i386/azerty/fr-latin1.map.gz"
echo "Only input fr-latin1. Use spacebar or the up/down arrowkeys 'q' exit keymaps"
read -p "Press Enter"
ls /usr/share/kbd/keymaps/**/*.map.gz | less
wait
read -p "Whats the name of the keyboard layout:? " KEYBOARD
loadkeys $KEYBOARD
timedatectl set-ntp true
timedatectl status
sleep 3
clear
echo "Second lets partition the hard drive!"
echo "Lets use cfdisk to partition the hard drive, it is by far the easiest tool"
read -p "Press Enter"
lsblk
echo
read -p "Hard drive to use:? Ex. sda or sdb .. ect " DRIVE
cfdisk /dev/$DRIVE
wait
echo "Example: Only sda1 sda2 sdb1 sdb2...etc not /dev/sda1 /dev/sdb2...etc
read -p "Whats the root partition:? " ROOTPAR
read -p "Whats the swap partition if any:? " SWAPPAR
read -p "Whats the boot or efi partition if any:? " BOOTPAR
if [[ $SWAPPAR = " " ]]; then
echo "No swap will be used"
sleep 2
else
mkswap /dev/$SWAPPAR
wait
swapon /dev/$SWAPPAR
fi
mkfs.ext4 /dev/$ROOTPAR
wait
clear
mount /dev/$ROOTPAR /mnt
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
read -p "Third lets set your timezone: Press Enter"
echo
ls /usr/share/zoneinfo/
echo
read -p "Whats your Region:? " REGION
echo
ls /usr/share/zoneinfo/$REGION
echo
read -p "Whats your City:? " CITY
echo
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
hwclock --systohc
clear
read -p "Fourth Localization, We need to edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8 and other needed locales: Press Enter"
pacman -S nano
nano  /etc/locale.gen
wait
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" > /etc/locale.conf
read -p "What do you want to name this computer aka hostname, used to distinguish you on the network:? " HOSTNAME
echo "$HOSTNAME" > /etc/hostname
touch /etc/hosts
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME" >> /etc/hosts
mkinitcpio -P
clear
passwd
read -p "Last lets install the boot loader: Press Enter"
pacman -S grub
grub-install /dev/$DRIVE
grub-mkconfig -o /boot/grub/grub.cfg

