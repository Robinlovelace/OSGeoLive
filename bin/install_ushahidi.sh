#!/bin/sh
# Copyright (c) 2009 The Open Source Geospatial Foundation.
# Licensed under the GNU LGPL.
# 
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License,
# or any later version.  This program is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY, without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details, either
# in the "LICENSE.LGPL.txt" file distributed with this software or at
# web page "http://www.fsf.org/licenses/lgpl.html".

# About:
# =====
# This script will install ushahidi

# Running:
# =======
# sudo ./install_ushahidi.sh

# Requires: Apache2, PHP5 mysql-server
#
# more install instructions can be found here /usr/share/ushahidi/readme.html
#
# Uninstall:
# ============
# sudo rm -rf /var/www/ushahidi/

# live disc's username is "user"
USER_NAME="user"
USER_HOME="/home/$USER_NAME"
TMP_DIR="/tmp/build_ushahidi"
mkdir -p "$TMP_DIR"

# Install ushahidi dependencies.
echo "Installing ushahidi"

apt-get --assume-yes install php5 php5-mcrypt php5-curl apache2 mysql-server libapache2-mod-php5 php5-mysql 
if [ ! -x "`which wget`" ] ; then
    echo "ERROR: wget is required, please install it and try again"
    exit 1
fi

cd "$TMP_DIR"

if [ ! -e "ushahidi.tgz" ] ; then 
   wget -O ushahidi.tgz --progress=dot:mega \
      "http://assets.ushahidi.com/downloads/ushahidi.tgz"
else
    echo "... Ushahidi already downloaded"
fi

# uncompress ushahidi
tar xzf "ushahidi.tgz"
mkdir /usr/local/share/ushahidi

cp -R ushahidi/ /usr/local/share/
ln -s /usr/local/share/ushahidi /var/www/ushahidi
chown -R www-data:www-data /usr/local/share/ushahidi


## (Note: on installing mysql-server you should have been prompted to
##  create a new root password. Repeat that here)
MYSQL_ADMIN_PW="user"
echo "
CREATE DATABASE ushahidi;
GRANT ALL PRIVILEGES ON ushahidi.* TO 'user'@'localhost' IDENTIFIED BY 'user';
" | mysql -u root -p "$MYSQL_ADMIN_PW"


#Add Launch icon to desktop
if [ ! -e /usr/share/applications/ushahidi.desktop ] ; then
   cat << EOF > /usr/share/applications/ushahidi.desktop
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Ushahidi
Comment=Ushahidi
Categories=Application;Internet;Relief;
Exec=firefox http://localhost/ushahidi
Icon=access
Terminal=false
StartupNotify=false
EOF
fi
cp /usr/share/applications/ushahidi.desktop "$USER_HOME/Desktop/"

echo "Done installing Ushahidi"
