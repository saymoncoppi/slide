#!/usr/bin/env bash
#
# apt-updates.sh
#=======================================================
# About: ...
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


# INSPIRATIONS
# https://wiki.ubuntu.com/ReducingDiskFootprint
# https://wiki.debian.org/ReduceDebian

# Text styles 
bold=$(tput bold)
normal=$(tput sgr0)

clear; set -e
printf "${bold}APT-BASE${normal}\n"
echo "--------------------------------------------------"

# RUN AS ROOT
#=======================================================
ROOT_UID=0 # check command avalibility
function has_command() {
    command -v $1 > /dev/null
}
if [ "$UID" -eq "$ROOT_UID" ]; then
# autoremove
# https://www.tecmint.com/disable-lock-blacklist-package-updates-ubuntu-debian-apt/
echo '
APT
{
  NeverAutoRemove
  {
	"^firmware-linux.*";
	"^linux-firmware$";
  };
  VersionedKernelPackages
  {
	# linux kernels
	"linux-image";
	"linux-headers";
	"linux-image-extra";
	"linux-signed-image";
	# kfreebsd kernels
	"kfreebsd-image";
	"kfreebsd-headers";
	# hurd kernels
	"gnumach-image";
	# (out-of-tree) modules
	".*-modules";
	".*-kernel";
	"linux-backports-modules-.*";
        # tools
        "linux-tools";
  };
  Never-MarkAuto-Sections
  {
	"metapackages";
	"contrib/metapackages";
	"non-free/metapackages";
	"restricted/metapackages";
	"universe/metapackages";
	"multiverse/metapackages";
  };
  Move-Autobit-Sections
  {
	"oldlibs";
	"contrib/oldlibs";
	"non-free/oldlibs";
	"restricted/oldlibs";
	"universe/oldlibs";
	"multiverse/oldlibs";
  };
};' > /etc/apt/apt.conf.d/01_custom_slide_autoremove

# remove apt-daily from boot
# https://ubuntu-mate.community/t/shorten-boot-time-apt-daily-service/12297/7

# Set security updates to auto
# https://debian-handbook.info/browse/stable/sect.regular-upgrades.html
# https://www.hiroom2.com/2016/05/18/ubuntu-16-04-auto-apt-update-and-apt-upgrade/

# remove old kernel using unattended-upgrades
# https://help.ubuntu.com/community/RemoveOldKernels
else
# SUDO CONFIRMATION
#=======================================================
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
fi

# SUCESS!
#=======================================================
echo "Done!" 
exit