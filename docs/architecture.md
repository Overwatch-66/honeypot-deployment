
# Architecture du Honeypot Cowrie

## Vue d'ensemble
Ce document décrit l'architecture technique du déploiement de notre honeypot Cowrie.

## Composants
1. **Cowrie Honeypot** - Logiciel principal simulant un système SSH
2. **Système de logging** - Collecte et stockage des événements
3. **Scripts d'analyse** - Traitement et analyse des données

## Diagramme d'architecture
flowchart TB
    Internet[Internet] --> Firewall[Firewall<br>Port 2222]
    Firewall --> Cowrie[Cowrie Honeypot]
    
    Cowrie --> Logs[Logs JSON/Text]
    Cowrie --> FS[Système de fichiers simulé]
    
    Attaquant[Attaquant] -.-> Internet
    Attaquant -.-> Cowrie
    Attaquant -.-> FS

## Flux de données
1. Un attaquant scanne les IPs publiques pour le port SSH
2. La connexion est redirigée vers Cowrie sur le port 2222
3. Cowrie simule un shell bash et enregistre toutes les interactions
4. Les données sont sauvegardées dans des fichiers logs et une base SQLite
5. Les scripts d'analyse traitent les logs pour générer des rapports

## Sécurité
- Cowrie fonctionne sous un utilisateur dédié sans privilèges
- Isolation du système hôte via environnement virtualisé
- Logs stockés avec permissions restrictives
- Aucune donnée sensible exposée dans le honeypot
