#!/bin/bash

# PATH explícito para Debian minimal
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

set -e
set -o pipefail
shopt -s nullglob

SERVICE_NAME="noip-duc.service"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"
BIN_PATH="/usr/bin/noip-duc"
ENV_DIR="/etc/noip"
ENV_FILE="$ENV_DIR/noip.env"
DOWNLOAD_URL="https://www.noip.com/download/linux/latest"
TMP_DIR="/tmp/noip-install"

function pause() {
    echo
    read -p "Pulsa ENTER para continuar..."
}

function check_distro() {
    if [ ! -f /etc/os-release ]; then
        echo "❌ No se puede detectar la distribución"
        exit 1
    fi

    . /etc/os-release

    case "$ID" in
        debian|ubuntu|linuxmint)
            echo "✔ Distribución soportada: $NAME"
            ;;
        *)
            echo "❌ Distribución NO soportada: $NAME"
            echo "Este script solo soporta Debian, Ubuntu y Linux Mint"
            exit 1
            ;;
    esac
}

function menu() {
    clear
    echo "================================="
    echo "  NO-IP Dynamic Update Client"
    echo "================================="
    echo "1) Instalar No-IP"
    echo "2) Desinstalar No-IP"
    echo "3) Salir"
    echo
    read -p "Selecciona una opción [1-3]: " OPTION
}

function install_noip() {
    check_distro
    echo
    echo ">>> Instalando No-IP DUC"
    echo

    read -p "Usuario No-IP: " NOIP_USER
    read -s -p "Contraseña No-IP: " NOIP_PASS
    echo

    echo ">>> Creando archivo de entorno seguro..."
    mkdir -p "$ENV_DIR"
    cat <<EOF > "$ENV_FILE"
NOIP_USER=$NOIP_USER
NOIP_PASS=$NOIP_PASS
EOF
    chmod 600 "$ENV_FILE"

    rm -rf "$TMP_DIR"
    mkdir -p "$TMP_DIR"
    cd "$TMP_DIR"

    echo ">>> Descargando paquete..."
    wget --content-disposition "$DOWNLOAD_URL"

    echo ">>> Descomprimiendo..."
    TAR_FILE=$(ls *.tar.gz | head -n 1)
    tar -xzf "$TAR_FILE"

    NOIP_DIR=$(find . -maxdepth 1 -type d -name "noip*" | head -n 1)
    cd "$NOIP_DIR/binaries"

    echo ">>> Instalando paquete amd64..."
    dpkg -i *amd64.deb

    echo ">>> Creando servicio systemd..."
    cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=No-IP Dynamic Update Client
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
EnvironmentFile=$ENV_FILE
ExecStart=$BIN_PATH -g all.ddnskey.com --username=\${NOIP_USER} --password=\${NOIP_PASS}
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

    chmod 644 "$SERVICE_FILE"

    systemctl daemon-reload
    systemctl enable "$SERVICE_NAME"
    systemctl start "$SERVICE_NAME"

    echo
    systemctl status "$SERVICE_NAME" --no-pager

    echo "✅ Instalación completada correctamente"
    pause
}

function uninstall_noip() {
    check_distro
    echo
    echo ">>> Desinstalación COMPLETA de No-IP DUC"
    echo

    systemctl stop "$SERVICE_NAME" 2>/dev/null || true
    systemctl disable "$SERVICE_NAME" 2>/dev/null || true

    rm -f "$SERVICE_FILE"
    systemctl daemon-reload
    systemctl reset-failed

    if dpkg -l | grep -q noip-duc; then
        dpkg --purge noip-duc || true
    fi

    rm -f "$BIN_PATH"
    rm -rf "$ENV_DIR" "$TMP_DIR"

    echo
    echo "✅ No-IP eliminado COMPLETAMENTE"
    echo "✔ Servicio"
    echo "✔ Binario"
    echo "✔ Credenciales"
    echo "✔ Restos"
    pause
}

while true; do
    menu
    case $OPTION in
        1) install_noip ;;
        2) uninstall_noip ;;
        3) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción inválida"; pause ;;
    esac
done
