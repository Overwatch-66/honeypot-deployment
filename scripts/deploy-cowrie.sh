#!/bin/bash
# Script d'installation automatique de Cowrie Honeypot
# Usage: sudo ./deploy-cowrie.sh

set -e

# Variables
COWRIE_USER="cowrie"
COWRIE_DIR="/opt/cowrie"
LOG_DIR="/var/log/cowrie"

echo "[+] Installation des dépendances système..."
apt-get update
apt-get install -y git python3-pip python3-venv python3-dev libssl-dev libffi-dev build-essential libmpfr-dev libmpc-dev

echo "[+] Création de l'utilisateur cowrie..."
if ! id "$COWRIE_USER" &>/dev/null; then
    useradd --create-home --shell /bin/bash $COWRIE_USER
fi

echo "[+] Clonage du repository Cowrie..."
if [ ! -d "$COWRIE_DIR" ]; then
    git clone https://github.com/cowrie/cowrie.git $COWRIE_DIR
    chown -R $COWRIE_USER:$COWRIE_USER $COWRIE_DIR
fi

echo "[+] Configuration de l'environnement Python..."
sudo -u $COWRIE_USER bash -c "cd $COWRIE_DIR && python3 -m venv cowrie-env"
sudo -u $COWRIE_USER bash -c "cd $COWRIE_DIR && source cowrie-env/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"

echo "[+] Configuration des fichiers de configuration..."
cp $COWRIE_DIR/etc/cowrie.cfg.dist $COWRIE_DIR/etc/cowrie.cfg

# Application de notre configuration personnalisée
cp config/cowrie.cfg $COWRIE_DIR/etc/cowrie.cfg
cp config/userdb.txt $COWRIE_DIR/etc/userdb.txt

echo "[+] Création des répertoires de logs..."
mkdir -p $LOG_DIR
chown -R $COWRIE_USER:$COWRIE_USER $LOG_DIR

echo "[+] Configuration du service systemd..."
cat > /etc/systemd/system/cowrie.service << EOF
[Unit]
Description=Cowrie SSH/Telnet Honeypot
After=network.target

[Service]
Type=simple
User=$COWRIE_USER
Group=$COWRIE_USER
WorkingDirectory=$COWRIE_DIR
ExecStart=$COWRIE_DIR/bin/cowrie start
ExecStop=$COWRIE_DIR/bin/cowrie stop
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

echo "[+] Démarrage du service Cowrie..."
systemctl daemon-reload
systemctl enable cowrie
systemctl start cowrie

echo "[+] Vérification du statut..."
sleep 5
systemctl status cowrie --no-pager

echo "[+] Installation terminée! Cowrie écoute sur le port 2222"
echo "[+] Logs disponibles dans: $LOG_DIR"
