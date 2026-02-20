[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/SoySH/service-noip-duc)
🚀 No-IP DUC Installer (Systemd Edition)

Script interactivo en Bash para instalar y desinstalar completamente el No-IP Dynamic Update Client (DUC) en sistemas Debian-based, creando un servicio systemd seguro y manejando credenciales mediante variables de entorno protegidas.

Pensado para:

VPS

servidores caseros

Debian minimal

admins que odian configuraciones manuales rotas 😤

✨ Características

✔ Instalación automática del cliente oficial No-IP DUC
✔ Compatible con Debian, Ubuntu y Linux Mint
✔ Servicio systemd persistente y resiliente
✔ Credenciales almacenadas en archivo seguro (chmod 600)
✔ Desinstalación realmente completa (sin basura)
✔ Menú interactivo simple
✔ Funciona en entornos minimal (PATH explícito)

📦 Requisitos

Sistema basado en:

Debian

Ubuntu

Linux Mint

Arquitectura amd64

Acceso root

Paquetes básicos:

apt install wget tar dpkg -y

📥 Instalación

Clona el repositorio o descarga el script:

git clone https://github.com/SoySH/service-noip-duc.git
cd service-noip-duc
chmod +x client-noip.sh
sudo ./client-noip.sh


Selecciona:

1) Instalar No-IP


El script te pedirá:

Usuario No-IP

Contraseña No-IP (entrada oculta)

Y se encargará de todo lo demás 👌

⚙️ Qué hace exactamente

Durante la instalación:

Descarga el paquete oficial desde:

https://www.noip.com/download/linux/latest


Instala el .deb amd64

Crea:

Binario: /usr/bin/noip-duc

Entorno seguro: /etc/noip/noip.env

Servicio systemd: /etc/systemd/system/noip-duc.service

Arranca y habilita el servicio al boot

🔐 Seguridad

Las credenciales NO se pasan por línea de comandos.

Se almacenan en:

/etc/noip/noip.env


Con permisos:

chmod 600


Y se cargan vía:

EnvironmentFile=/etc/noip/noip.env


🧹 Desinstalación completa

Desde el menú selecciona:

2) Desinstalar No-IP


El script elimina TODO:

✔ Servicio systemd
✔ Binario
✔ Paquete noip-duc
✔ Credenciales
✔ Archivos temporales

Sin restos. Sin fantasmas. Sin traumas. 🧼

📂 Estructura generada
/usr/bin/noip-duc
/etc/noip/noip.env
/etc/systemd/system/noip-duc.service

🛠 Servicio systemd

Nombre:

noip-duc.service


Comandos útiles:

systemctl status noip-duc
systemctl restart noip-duc
journalctl -u noip-duc -f

⚠️ Notas

El script falla a propósito si algo sale mal (set -e)

Solo soporta amd64

No probado en otras distros (y no pretende serlo)
