#!/usr/bin/env bash
#
# apt-base.sh
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

# no install recommends
# https://ubuntu.com/blog/we-reduced-our-docker-images-by-60-with-no-install-recommends
echo '
APT::Install-Recommends "0" ;
APT::Install-Suggests "0" ;
Acquire::Languages { "none";
Apt::AutoRemove::SuggestsImportant "false";
Acquire::GzipIndexes "true";
Acquire::CompressionTypes::Order:: "gz";
DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };
APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };
Dir::Cache::pkgcache "";
Dir::Cache::srcpkgcache "";' > /etc/apt/apt.conf.d/01_custom_slide_nocache_norecommends


# no docs
# https://wiki.ubuntu.com/ReducingDiskFootprint#Drop_unnecessary_files
# https://blog.sleeplessbeastie.eu/2018/09/03/how-to-remove-useless-localizations/
# remove zoneinfo https://github.com/tianon/docker-brew-debian/issues/48
# https://raphaelhertzog.com/2010/11/15/save-disk-space-by-excluding-useless-files-with-dpkg/
echo "
path-exclude /usr/share/doc/*
# we need to keep copyright files for legal reasons
path-include /usr/share/doc/*/copyright
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
# lintian stuff is small, but really unnecessary
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
path-exclude /usr/share/locale/*
path-include /usr/share/locale/en*
" > /etc/dpkg/dpkg.cfg.d/01_custom_slide_nodocs

else
# SUDO CONFIRMATION
#=======================================================
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
fi

# SUCESS!
#=======================================================
echo "Done!" 
exit