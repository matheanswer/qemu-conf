#!/usr/bin/zsh
number=${1:-"0"}
host="10.0.0.3"
printf -v macaddr "52:54:00:00:00:%02x" $number
port=$((5700 + $number))
url="http://vnc.home?path=&host=$host&port=$port"

echo "noVNC : $url"

#echo -e "instance-id: iid-local01\nlocal-hostname: cloudimg" > meta-data
#use uuidgen to make random isntance-id ?
cloud-localds images/seed.img user-data.yaml meta-data.yaml

#create snapshot
#qemu-img create -b Arch-Linux-x86_64-cloudimg.qcow2 -F qcow2 -f qcow2 images/Arch-Linux-x86_64-cloudimg-snapshot.qcow2 20G

#copy and resize
#cp images/Arch-Linux-x86_64-cloudimg.qcow2 images/Arch-Linux-x86_64-cloudimg-copy.qcow2
#qemu-img resize images/Arch-Linux-x86_64-cloudimg-snapshot.qcow2 20G

printf -v version %s $(qemu-system-x86_64 --version | grep -Eom 1 "[0-9.]+")

OPTIONS=(
-m 4G
-smp 4
-cpu host
-enable-kvm
-device virtio-tablet-pci
-nic bridge,br=br0,model=virtio-net-pci,mac="$macaddr"
-drive if=virtio,format=qcow2,file=images/Arch-Linux-x86_64-cloudimg-snapshot.qcow2
-drive if=virtio,format=raw,file=images/seed.img
-smbios type=1,manufacturer="QEMU",product="QEMU/KVM",version="$version",family="Virtual Machine"
-vnc :"$number",websocket=on
#set boot device, c=disk, d=cdrom
-snapshot
#-nographic
)

qemu-system-x86_64 "${OPTIONS[@]}"
