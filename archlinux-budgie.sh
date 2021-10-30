echo "Set the console keyboard layout"
loadkeys uk
echo "Update the system clock"
timedatectl set-ntp true
echo "Partitioning the disks"
pacman -Sy parted
parted /dev/sda mklabel gpt mkpart "EFI system partition" fat32 1MiB 300MiB set 1 esp on mkpart "root partition" ext4 300Mib 40GiB mkpart "home partition 40GiB 100%
echo "Mounting the file systems"
mount /dev/sda/sda2 /mnt
mkdir /mnt/home
mount /dev/sda/sda3 /mnt/home
echo "Installing essential packages"
pacstrap /mnt base linux linux-firmware
echo "Generating an fstab file"
genfstab -U /mnt >> /mnt/etc/fstab
echo "Changing root into the new system"
arch-chroot /mnt
echo "Setting the time zone"
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
echo "Generating hwclock"
hwclock --systohc
echo "Localization"
sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo "Create the hostname file"
echo "archlinux" >> /etc/hostname
echo "Bootloader is grub"
pacman -Sy grub
echo "Set the root password"
passwd
echo "Creating user"
useradd -M user
echo "Set the user password"
passwd user
echo "Giving the user sudo"
usermod -a -G wheel user
pacman -Sy sudo
sed -i 's/# %wheel ALL=(ALL) ALL/ %wheel ALL=(ALL) ALL/g' /etc/sudoers
echo "Installing desktop"
pacman -Sy budgie-desktop network-manager
pacman -Sy gdm
