#!/bin/bash

NOM="Debian1"
RAM=4096
DISK=65536
OSTYPE="Debian_64"

VBoxManage showvminfo "$NOM" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "La VM $NOM existe deja, suppression..."
    VBoxManage unregistervm "$NOM" --delete
    if [ $? -ne 0 ]; then
        echo "Erreur : impossible de supprimer la VM existante $NOM"
        exit 1
    fi
fi

echo "Creation de la VM $NOM..."
VBoxManage createvm --name "$NOM" --ostype "$OSTYPE" --register
if [ $? -ne 0 ]; then
    echo "Erreur : echec de la creation de la VM $NOM"
    exit 1
fi

VBoxManage modifyvm "$NOM" --memory "$RAM" --nic1 nat

VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$NOM/$NOM.vdi" --size "$DISK"
VBoxManage storagectl "$NOM" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$NOM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd \
    --medium "$HOME/VirtualBox VMs/$NOM/$NOM.vdi"

echo "VM $NOM creee avec succes."
