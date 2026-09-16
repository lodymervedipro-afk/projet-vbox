#!/bin/bash

RAM=4096
DISK=65536
OSTYPE="Debian_64"

usage() {
    echo "Usage: $0 <L|N|S|D|A> [nom_vm]"
    echo "  L          : lister les machines enregistrees"
    echo "  N nom_vm   : creer une nouvelle machine"
    echo "  S nom_vm   : supprimer une machine"
    echo "  D nom_vm   : demarrer une machine"
    echo "  A nom_vm   : arreter une machine"
    exit 1
}

lister() {
    VBoxManage list vms
}

creer() {
    local nom="$1"

    VBoxManage showvminfo "$nom" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "La VM $nom existe deja, suppression..."
        VBoxManage unregistervm "$nom" --delete
        if [ $? -ne 0 ]; then
            echo "Erreur : impossible de supprimer la VM existante $nom"
            exit 1
        fi
    fi

    VBoxManage createvm --name "$nom" --ostype "$OSTYPE" --register
    if [ $? -ne 0 ]; then
        echo "Erreur : echec de la creation de la VM $nom, verifiez le nom"
        exit 1
    fi

    VBoxManage modifyvm "$nom" --memory "$RAM" --nic1 nat

    VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$nom/$nom.vdi" --size "$DISK"
    VBoxManage storagectl "$nom" --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach "$nom" --storagectl "SATA Controller" --port 0 --device 0 --type hdd \
        --medium "$HOME/VirtualBox VMs/$nom/$nom.vdi"

    echo "VM $nom creee avec succes."
}

supprimer() {
    local nom="$1"
    VBoxManage unregistervm "$nom" --delete
    if [ $? -ne 0 ]; then
        echo "Erreur : echec de la suppression de la VM $nom, verifiez le nom"
        exit 1
    fi
    echo "VM $nom supprimee."
}

demarrer() {
    local nom="$1"
    VBoxManage startvm "$nom" --type headless
    if [ $? -ne 0 ]; then
        echo "Erreur : echec du demarrage de la VM $nom, verifiez le log"
        exit 1
    fi
    echo "VM $nom demarree."
}

arreter() {
    local nom="$1"
    VBoxManage controlvm "$nom" poweroff
    if [ $? -ne 0 ]; then
        echo "Erreur : echec de l'arret de la VM $nom"
        exit 1
    fi
    echo "VM $nom arretee."
}

if [ $# -lt 1 ]; then
    usage
fi

ACTION="$1"
NOM="$2"

case "$ACTION" in
    L)
        lister
        ;;
    N)
        [ -z "$NOM" ] && usage
        creer "$NOM"
        ;;
    S)
        [ -z "$NOM" ] && usage
        supprimer "$NOM"
        ;;
    D)
        [ -z "$NOM" ] && usage
        demarrer "$NOM"
        ;;
    A)
        [ -z "$NOM" ] && usage
        arreter "$NOM"
        ;;
    *)
        echo "Action inconnue: $ACTION"
        usage
        ;;
esac
