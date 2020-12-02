#!/bin/bash
#Creator: David Parra-Sandoval
#Date: 11/01/2020
#Last Modified: 11/02/2020
clear
read -p "This installer script has 2 phase's, is this your first time running the script [y/n]? " YN
if [[ $YN = [yY]* ]]; then
echo "This script will guide you to install Arch-Linux:"
read -p "Press ANY key to continue WARNING STILL IN THE WORKS"
clear
echo "First lets select your keyboard layout, only worry about the (NAME) minus the extension of (.map.gz)"
echo "So if your keyboard layout is in /usr/share/kbd/keymaps/i386/azerty/fr-latin1.map.gz"
echo "Only input fr-latin1, Use spacebar or the up/down arrowkeys [q] exit keymaps"
read -p "Press Enter"
ls /usr/share/kbd/keymaps/**/* | less
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
echo "NOTE! Only use sda1 sda2 sdb1 sdb2...etc not /dev/sda1 /dev/sdb2...etc below"
read -p "Whats the root partition:? " ROOTPAR
read -p "Whats the swap partition if any:? " SWAPPAR
read -p "Whats the boot or efi partition if any:? " BOOTPAR
case $SWAPPAR in
""|" " ) echo "No swap created!"; sleep 3 ;;
sd* ) 
mkswap /dev/$SWAPPAR
swapon /dev/$SWAPPAR
;;
esac
case $BOOTPAR in
""|" " ) echo "No boot/efi created!"; sleep 3 ;;
sd* ) 
mkfs.fat -F32 /dev/$BOOTPAR
esac
mkfs.ext4 /dev/$ROOTPAR
wait
clear
mount /dev/$ROOTPAR /mnt
pacstrap /mnt base linux linux-firmware
wait
genfstab -U /mnt >> /mnt/etc/fstab
echo "Now chrooting into the new installation, to finalize the install."
echo "Script is going to terminate re-execute ./archinstaller.sh to continue"
read -p "archinstaller.sh will be copied to the new root partition: Press Enter"
cp archinstaller.sh /mnt
arch-chroot /mnt
else
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
echo "Fourth Localization, We need to edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8 and other needed locales:"
read -p "Press Enter: nano editor will be installed."
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
echo "root password"
passwd
echo "Next lets install the grub bootloader: if you created an efi partition type efi"
read -p "To install the necessary packages for an efi setup : " EFI
case $EFI in
""|" " )
pacman -S grub
lsblk
read -p "Install grub on drive:? Ex: sda sdb sdc " DRIVE
grub-install /dev/$DRIVE
grub-mkconfig -o /boot/grub/grub.cfg ;;
efi )
pacman -S grub efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
read -p "whats the boot/efi partition:? " BOOTPAR
mount /dev/$BOOTPAR /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg ;;
esac
read -p "Now installing networkmanager so when you reboot you'll have an internet connection: Press Enter"
pacman -S networkmanager
systemctl enable NetworkManager
fi
##Thanks to DT Youtube channel:DistroTube
##https://wiki.archlinux.org/index.php/installation_guide
