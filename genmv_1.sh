#!/bin/bash
# genmv_1.sh - Creation d'une VM Debian1 fixe, pause, puis destruction
# Etape 1 du sujet SAE 51

NOM="Debian1"
RAM=4096
DISK=65536   # en MiB (64 GiB)
OSTYPE="Debian_64"

echo "Creation de la VM $NOM..."
VBoxManage createvm --name "$NOM" --ostype "$OSTYPE" --register
VBoxManage modifyvm "$NOM" --memory "$RAM" --nic1 nat

VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$NOM/$NOM.vdi" --size "$DISK"
VBoxManage storagectl "$NOM" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$NOM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd \
    --medium "$HOME/VirtualBox VMs/$NOM/$NOM.vdi"

echo "VM $NOM creee. Verifiez dans l'interface graphique de VirtualBox."
read -p "Appuyez sur Entree pour detruire la VM..."

echo "Destruction de la VM $NOM..."
VBoxManage unregistervm "$NOM" --delete
echo "VM $NOM detruite. Verifiez qu'elle n'apparait plus dans la GUI."
