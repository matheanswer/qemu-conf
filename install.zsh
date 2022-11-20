#!/usr/bin/zsh
number=${1:-"0"}
host="10.0.0.3"
printf -v macaddr "52:54:00:00:00:%02x" $number
port=$((5700 + $number))
url="http://vnc.home?path=&host=$host&port=$port"

echo "noVNC : $url"

OPTIONS=(
-m 4G
-smp 4
-cpu host
-enable-kvm
-device virtio-tablet-pci
-nic bridge,br=br0,model=virtio-net-pci,mac=$macaddr
-drive index=1,if=virtio,media=disk,file=images/arch.img
-drive index=0,media=cdrom,file=images/archlinux-2022.08.05-x86_64.iso
-smbios type=1,manufacturer="QEMU",product="QEMU/KVM Virtual Machine",version="",family="Virtual Machine"
-vnc :$number,websocket=on
#set boot device, c=disk, d=cdrom
-boot d
#-nographic
)

qemu-system-x86_64 "${OPTIONS[@]}"
