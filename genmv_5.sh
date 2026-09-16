#!/bin/bash
# genmv_5.sh - Ajout du boot PXE + serveur TFTP interne VBox pour installation Debian netinst
# Etape 5 du sujet SAE 51

RAM=4096
DISK=65536
OSTYPE="Debian_64"

# Dossier contenant les fichiers de boot reseau Debian (netboot.tar.gz extrait)
# IMPORTANT : chemin absolu obligatoire pour VBoxManage
TFTP_DIR="$HOME/tftpboot"
TFTP_FILE="pxelinux.0"

usage() {
    echo "Usage: $0 <L|N|S|D|A> [nom_vm]"
    exit 1
}

lister() {
    VBoxManage list vms > /tmp/liste_vms.txt

    while read -r ligne; do
        nom_vm=$(echo "$ligne" | awk -F'"' '{print $2}')
        date_creation=$(VBoxManage getextradata "$nom_vm" date_creation 2>/dev/null | sed -n 's/^Value: //p')
        utilisateur=$(VBoxManage getextradata "$nom_vm" utilisateur 2>/dev/null | sed -n 's/^Value: //p')
        echo "$nom_vm | creee le: ${date_creation:-inconnue} | par: ${utilisateur:-inconnu}"
    done < /tmp/liste_vms.txt

    rm -f /tmp/liste_vms.txt
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

    # Boot PXE en priorite, disque dur en second recours
    VBoxManage modifyvm "$nom" --boot1 net --boot2 disk --boot3 none --boot4 none

    # Configuration du serveur TFTP interne (associe au NIC1 en mode NAT)
    VBoxManage modifyvm "$nom" --nattftpprefix1 "$TFTP_DIR"
    VBoxManage modifyvm "$nom" --nattftpfile1 "$TFTP_FILE"

    # Metadonnees
    VBoxManage setextradata "$nom" date_creation "$(date '+%Y-%m-%d %H:%M')"
    VBoxManage setextradata "$nom" utilisateur "$USER"

    echo "VM $nom creee avec succes (boot PXE configure)."
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
    VBoxManage startvm "$nom"
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

# --- Main ---
if [ $# -lt 1 ]; then
    usage
fi

ACTION="$1"
NOM="$2"

case "$ACTION" in
    L) lister ;;
    N) [ -z "$NOM" ] && usage; creer "$NOM" ;;
    S) [ -z "$NOM" ] && usage; supprimer "$NOM" ;;
    D) [ -z "$NOM" ] && usage; demarrer "$NOM" ;;
    A) [ -z "$NOM" ] && usage; arreter "$NOM" ;;
    *) echo "Action inconnue: $ACTION"; usage ;;
esac
