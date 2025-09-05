# Guide d'installation de Cowrie Honeypot

## Prérequis
- Ubuntu 20.04 LTS ou plus récent
- 2GB de RAM minimum
- 10GB d'espace disque
- Accès Internet

## Installation automatique
1. Cloner ce repository
2. Exécuter le script de déploiement:
```bash
sudo ./scripts/deploy-cowrie.sh
```
## Installation manuelle
1. Mettre à jour le système
```bash
sudo apt update && sudo apt upgrade -y
```
2. Installer les dépendances:
```bash
sudo apt install -y git python3-pip python3-venv python3-dev libssl-dev libffi-dev build-essential libmpfr-dev libmpc-dev
```
3. Créer un utilisateur dédié
```bash
sudo useradd --create-home --shell /bin/bash cowrie
```
4. Installer Cowrie
```bash
sudo -u cowrie -i
git clone https://github.com/cowrie/cowrie.git
cd cowrie
python3 -m venv cowrie-env
source cowrie-env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
exit
```
5. Configurer Cowrie
```bash
sudo cp /opt/cowrie/etc/cowrie.cfg.dist /opt/cowrie/etc/cowrie.cfg
```
6. Démarrer Cowrie
```bash
sudo -u cowrie /opt/cowrie/bin/cowrie start
```

 ## Vérification
 Vérifiez que le service fonctionne:
 ```bash
sudo systemctl status cowrie
```
Consultez les logd:
```bash
tail -f /var/log/cowrie/cowrie.log
```
