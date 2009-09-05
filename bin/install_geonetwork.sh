#!/bin/sh
#################################################
# 
# Purpose: Installation of GeoNetwork into Xubuntu
# Authors: Ricardo Pinho <ricardo.pinho@gisvm.com>
#          Simon Pigot <simon.pigot@csiro.au> 
#################################################
# Copyright (c) 2009 Open Geospatial Foundation
#
# Licensed under the GNU LGPL.
# 
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License,
# or any later version.  This library is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY, without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details, either
# in the "LICENSE.LGPL.txt" file distributed with this software or at
# web page "http://www.fsf.org/licenses/lgpl.html".
##################################################

# About:
# =====
# This script will install geonetwork into Xubuntu
# stable version: v2.4.1 (20 August 2009) (also the manuals)
# based on Jetty + Geoserver + McKoy
# Installed at /usr/lib/geonetwork
# Port number =8880
#
# To start geonetwork
# cd /usr/lib/geonetwork
# sudo ./start-geonetwork.sh 
#
# To stop geoserver
# sudo ./stop-geonetwork.sh
#
# To enter geoserver
# http://localhost:8880/geonetwork

# Running:
# =======
# sudo ./install_geonetwork.sh

TMP="/tmp/geonetwork_downloads"
INSTALL_FOLDER="/usr/lib"
#DATA_FOLDER="/usr/local/share"
GEONETWORK_FOLDER="$INSTALL_FOLDER/geonetwork"
BIN="/usr/bin"
USER_NAME="user"
USER_HOME="/home/$USER_NAME"
 
## Setup things... ##
 
# check required tools are installed
# (should we also verify java???)
if [ ! -x "`which wget`" ] ; then
   echo "ERROR: wget is required, please install it and try again" 
   exit 1
fi
# create tmp folders
mkdir $TMP
cd $TMP



## Install Application ##

# get geonetwork
if [ -f "geonetwork-install-2.4.1-0.jar" ]
then
   echo "geonetwork-install-2.4.1-0.jar has already been downloaded."
else
   wget http://freefr.dl.sourceforge.net/project/geonetwork/GeoNetwork_opensource/v2.4.1/geonetwork-install-2.4.1-0.jar
fi


## Get Install config files ##

# Download XML file that defines install location = 
if [ -f "install.xml" ]
then
   echo "install.xml has already been downloaded."
else
   wget https://svn.osgeo.org/osgeo/livedvd/gisvm/trunk/geonetwork-conf/install.xml
fi

# Download jetty.xml file to listen all adsresses and change Port to 8880 
if [ -f "jetty.xml" ]
then
   echo "jetty.xml has already been downloaded."
else
   wget https://svn.osgeo.org/osgeo/livedvd/gisvm/trunk/geonetwork-conf/jetty.xml
fi


# run installation
sudo java -jar geonetwork-install-2.4.1-0.jar install.xml


# copy jetty.xml to $GEONETWORK_FOLDER/bin
sudo cp jetty.xml $GEONETWORK_FOLDER/bin/jetty.xml


# fix permissions on installed software
sudo chown -R $USER_NAME:$USER_NAME $GEONETWORK_FOLDER


# create startup, shutdown desktop entries
if [ -f "start_geonetwork.desktop" ]
then
	echo "start_geonetwork.desktop has already been downloaded"
else
	wget https://svn.osgeo.org/osgeo/livedvd/gisvm/trunk/geonetwork-conf/start_geonetwork.desktop
fi
cp start_geonetwork.desktop $USER_HOME/Desktop/start_geonetwork.desktop
chown $USER_NAME:$USER_NAME $USER_HOME/Desktop/start_geonetwork.desktop


if [ -f "stop_geonetwork.desktop" ]
then
	echo "stop_geonetwork.desktop has already been downloaded"
else
	wget https://svn.osgeo.org/osgeo/livedvd/gisvm/trunk/geonetwork-conf/stop_geonetwork.desktop
fi
cp stop_geonetwork.desktop $USER_HOME/Desktop/stop_geonetwork.desktop
chown $USER_NAME:$USER_NAME $USER_HOME/Desktop/stop_geonetwork.desktop

if [ -f "geonetwork.desktop" ]
then
	echo "geonetwork.desktop has already been downloaded"
else
	wget https://svn.osgeo.org/osgeo/livedvd/gisvm/trunk/geonetwork-conf/geonetwork.desktop
fi
cp geonetwork.desktop $USER_HOME/Desktop/geonetwork.desktop
chown $USER_NAME:$USER_NAME $USER_HOME/Desktop/geonetwork.desktop

exit 0
