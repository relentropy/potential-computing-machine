ehco "Set the console keyboard layout"
loadkeys uk
ehco "Update the system clock"
timedatectl set-ntp true
ehco "Partitioning the disks"
pacman -Sy parted
parted /dev/sda mklabel gpt mkpart "EFI system partition" fat32 1MiB 300MiB set 1 esp on mkpart "root partition" ext4 300Mib 40GiB mkpart "home partition 40GiB 100%
ehco "Mounting the file systems"
mount /dev/sda/sda2 /mnt
mkdir /mnt/home
mount /dev/sda/sda3 /mnt/home
ehco "Installing essential packages"
pacstrap /mnt base linux linux-firmware
ehco "Generating an fstab file"
genfstab -U /mnt >> /mnt/etc/fstab
ehco "Changing root into the new system"
arch-chroot /mnt
ehco "Setting the time zone"
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
ehco "Generating hwclock"
hwclock --systohc
ehco "Localization"
sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
ehco "Create the hostname file"
echo "archlinux" >> /etc/hostname
ehco "Bootloader is grub"
pacman -Sy grub
ehco "Set the root password"
passwd
ehco "Creating user"
useradd -M user
ehco "Set the user password"
passwd user
ehco "Giving the user sudo"
usermod -a -G wheel user
pacman -Sy sudo
sed -i 's/# %wheel ALL=(ALL) ALL/ %wheel ALL=(ALL) ALL/g' /etc/sudoers
ehco "Installing DE/DM"
pacman -Sy budgie-desktop network-manager
pacman -Sy gdm
