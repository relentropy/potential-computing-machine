loadkeys uk
timedatectl set-ntp true
pacman -Sy parted
parted /dev/sda mklabel gpt mkpart "EFI system partition" fat32 1MiB 300MiB set 1 esp on mkpart "root partition" ext4 300Mib 40GiB mkpart "home partition 40GiB 100%
mount /dev/sda/sda2 /mnt
mkdir /mnt/home
mount /dev/sda/sda3 /mnt/home
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo "archlinux" >> /etc/hostname
passwd
useradd -M user
passwd user
usermod -a -G wheel user
pacman -Sy sudo
sed -i 's/# %wheel ALL=(ALL) ALL/ %wheel ALL=(ALL) ALL/g' /etc/sudoers
pacman -Sy budgie-desktop network-manager
pacman -Sy gdm
