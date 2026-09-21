# Journal de bord

(remplacer les items en majuscule)

- Automatisation de la création de machines VirtualBox (projet genmv)
- Lody Mervedi
- Divine Ouboura
- 16 septembre 2026

## Séance n° 1

- 16 septembre 2026 - matinée (environ 9h30 à 12h00)

**Travail effectué**

La séance a commencé par l'installation de VirtualBox sur une machine Ubuntu physique.
Le paquet fourni par les dépôts Ubuntu (version 7.0.16) a échoué à l'installation : le
module noyau vboxdrv ne compilait pas, en raison de symboles liés à KVM devenus
inaccessibles aux modules externes dans les noyaux récents. Après diagnostic, VirtualBox
a été réinstallé depuis le dépôt officiel Oracle (version 7.2.18), ce qui a résolu le
problème.

Une fois l'environnement fonctionnel, les quatre premières versions du script genmv ont
été développées et testées successivement. La version 1 crée une VM Debian1 fixe, avec
une pause avant destruction, ce qui a permis de vérifier visuellement dans l'interface
graphique VirtualBox que la machine était bien créée avec les bonnes caractéristiques
puis correctement supprimée. La version 2 a ajouté la vérification d'existence d'une VM
avant création, rendant le script rejouable sans erreur. La version 3 a introduit la
gestion des cinq actions demandées (lister, créer, supprimer, démarrer, arrêter) via des
arguments en ligne de commande, chacune testée individuellement. La version 4 a ajouté
l'enregistrement de métadonnées (date de création, utilisateur) sur chaque VM, affichées
lors du listage.

En parallèle, le dépôt GitHub du projet (projet-vbox) a été créé, git a été installé et
configuré, et les quatre scripts ont été versionnés et poussés sur le dépôt distant.

**A faire à la prochaine séance**

Nettoyer les machines virtuelles de test restantes. Compléter et relire le rapport
usage.md avec les noms définitifs des membres de l'équipe. Décider si la version 5 (boot
PXE et installation automatisée) et les fonctionnalités optionnelles sont développées.

**Difficultés rencontrées**

Incompatibilité entre la version de VirtualBox des dépôts Ubuntu et le noyau de la
machine (résolue via le dépôt officiel Oracle). Configuration initiale de git (identité
non renseignée) et de l'authentification GitHub, qui nécessite désormais un token
d'accès personnel plutôt qu'un mot de passe classique pour les opérations en ligne de
commande.

**Remarques sur la séance**

Un assistant IA et des tutoriels en ligne ont été utilisés en support pour la rédaction
du code et la résolution des problèmes techniques rencontrés.

## Séance n° 2

- 21 septembre 2026 - matinée

**Travail effectué**

Cette séance a été consacrée à la re-vérification complète du travail réalisé lors de la
première séance. Les versions 1 à 4 du script genmv ont été retestées intégralement, afin
de confirmer que la création, l'idempotence, la gestion des cinq actions (lister, créer,
supprimer, démarrer, arrêter) et l'enregistrement des métadonnées fonctionnaient toujours
correctement. Le développement de la version 5, qui ajoute le boot PXE de la machine
virtuelle via le serveur TFTP interne de VirtualBox, a également été entamé.

**A faire à la prochaine séance**

Terminer et valider la version 5 (boot PXE et TFTP). Finaliser le rapport usage.md et le
journal de bord. Nettoyer les machines virtuelles de test.

**Difficultés rencontrées**

La mise en place de la version 5 s'est révélée nettement plus difficile que les
précédentes. La configuration du boot PXE et du serveur TFTP interne de VirtualBox a
nécessité plusieurs tentatives avant d'aboutir, avec des erreurs peu explicites côté
VirtualBox (échecs de démarrage réseau sans message clair sur leur origine).

**Remarques sur la séance**

Un assistant IA et des tutoriels en ligne ont été utilisés en support pour la rédaction
du code et la résolution des problèmes techniques rencontrés.

## Séance n° 3

- date - heure
- Travail effectué
- A faire à la prochaine séance
- Difficultés rencontrées
- Remarques sur la séances (membre absent, pbe technique, ...)

...
