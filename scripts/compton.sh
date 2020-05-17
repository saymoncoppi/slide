#!/usr/bin/env bash
#
# compton.sh
#=======================================================
# About: compton
# Source : https://github.com/saymoncoppi/slide
# Author:     Saymon Coppi <saymoncoppi@gmail.com>
# Maintainer: Saymon Coppi <saymoncoppi@gmail.com>
# Created: /05/2020
#
# License:
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Text styles 
bold=$(tput bold)
normal=$(tput sgr0)

clear; set -e
printf "${bold}Compton Install${normal}\n"
echo "--------------------------------------------------"

# RUN AS ROOT
#=======================================================
ROOT_UID=0 # check command avalibility
function has_command() {
    command -v $1 > /dev/null
}
if [ "$UID" -eq "$ROOT_UID" ]; then

# INSTALL COMPTON
function install_compton {

git clone https://github.com/tryone144/compton
cd compton
aptinst -y libx11-dev libxcomposite-dev libxdamage-dev libxrender-dev libxrandr-dev libxinerama-dev libconfig-dev libdbus-1-dev libdrm-dev libgl1-mesa-dev libpcre3-dev 
make
aptinst -y --no-install-recommends asciidoc docbook-xml xsltproc xmlto
make docs
sudo make install #checkinstall
cd ..
rm -rfv compton
aptinst -y libconfig9
aptpurge -y libpthread-stubs0-dev libx11-dev libx11-doc libxau-dev libxcb1-dev libxdmcp-dev x11proto-core-dev x11proto-dev xorg-sgml-doctools xtrans-dev libxcomposite-dev libxext-dev libxfixes-dev x11proto-composite-dev x11proto-fixes-dev x11proto-xext-dev libxdamage-dev x11proto-damage-dev libxrender-dev libxrandr-dev x11proto-randr-dev libxinerama-dev x11proto-xinerama-dev libconfig-dev libconfig-doc libdbus-1-dev libdrm-dev libgl1-mesa-dev libgles1 libglvnd-core-dev libglvnd-dev libopengl0 libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-glx0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0-dev libxshmfence-dev libxxf86vm-dev mesa-common-dev x11proto-xf86vidmode-dev libpcre16-3 libpcre3-dev libpcre32-3 libpcrecpp0v5 asciidoc asciidoc-base asciidoc-common libxml2-utils xsltproc asciidoc asciidoc-base asciidoc-common docbook-xsl xmlto
cp /usr/share/applications/compton.desktop ~/.config/autostart/
echo 'OnlyShowIn=XFCE;' >> ~/.config/autostart/compton.desktop
sed -i 's/TryExec/#TryExec/g' ~/.config/autostart/compton.desktop
wget -O ~/.config/compton.conf http://my.opendesktop.org/index.php/s/SpcapKgySxmHmzG/download #update-link
xfconf-query -c xfwm4 -np /general/use_compositing -T false

}

install_compton

# TEST COMPTON
function test_compton {
nohup $(gtk-launch compton.desktop &)
}

test_compton


else
# SUDO CONFIRMATION
#=======================================================
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
fi

# SUCESS!
#=======================================================
echo "Done!" 
exit