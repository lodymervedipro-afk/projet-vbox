# Projet genmv - Automatisation de la création de machines VirtualBox

**Auteurs :** [Nom Prénom 1], [Nom Prénom 2]
**Date :** [à compléter]

## Résumé

[4-5 lignes max décrivant le contenu du document : ce que fait le script,
comment l'utiliser, les grandes lignes des choix techniques.]

## Utilisation

```
./genmv_X.sh L              # lister les machines enregistrées
./genmv_X.sh N nom_vm        # créer une nouvelle machine
./genmv_X.sh S nom_vm        # supprimer une machine
./genmv_X.sh D nom_vm        # démarrer une machine
./genmv_X.sh A nom_vm        # arrêter une machine
```

## Choix techniques

- RAM et taille disque : configurables en tête de script (variables `RAM` et `DISK`).
- [à compléter au fil des versions]

## Historique des versions

- **v1** : création fixe d'une VM Debian1, pause, destruction.
- **v2** : idempotence — vérification/suppression d'une VM du même nom avant création.
- **v3** : gestion d'arguments non-interactive (L/N/S/D/A).
- **v4** : métadonnées (date de création, utilisateur) via setextradata/getextradata.
- **v5** : [à compléter]

## Difficultés rencontrées

- [à compléter]

## Astuces techniques

- [à compléter]

## Limites

- [à compléter]
