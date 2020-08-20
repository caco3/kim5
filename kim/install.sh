#!/bin/bash
#
# This file is part of Kde Image Menu (KIM). KIM was created by
# Charles Bouveyron <charles.bouveyron@free.fr>.
# 
# KIM is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# any later version.
# 
# KIM is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Foobar; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

if [ ! `command -v kf5-config` ]; then
	echo "KDE Image Menu is running under KDE Framework 5, but I can't find executive \"kf5-config\".  Please check your system installation."
	exit
elif [ ! `command -v montage` ]; then
	echo "Can not find executive \"montage\".  Please install it which may be in package \"graphicsmagick\"."
	exit
elif [ ! `command -v mogrify` ]; then
	echo "Can not find executive \"mogrify\".  Please install it which may be in package \"graphicsmagick\"."
	exit
elif [ ! `command -v convert` ]; then
	echo "Can not find executive \"convert\".  Please install it."
	exit
elif [ ! `command -v xwd` ]; then
	echo "Can not find executive \"xwd\".  Please install it."
	exit
elif [ ! `command -v ffmpeg` ]; then
	echo "Can not find executive \"ffmpeg\".  Please install it which may be in package \"ffmpeg\"."
	exit
fi


kdeinstdir=`kf5-config --prefix`

if [[ $? != 0 ]]; then
    "Error fetching the KDE install prefix. Exiting..."
    exit 1
fi

cp -f src/kim_*.desktop $kdeinstdir/share/kservices5/ServiceMenus/
cp -f src/bin/kim_* $kdeinstdir/bin/
chmod a+rx $kdeinstdir/bin/kim_*
chmod a+r $kdeinstdir/share/kservices5/ServiceMenus/kim_*.desktop
#mv -f $kdeinstdir/share/kde4/services/ServiceMenus/imageconverter.desktop $kdeinstdir/share/kde4/services/ServiceMenus/imageconverter.desktop~ 2>/dev/null

mkdir -p $kdeinstdir/share/kim
cp COPYING $kdeinstdir/share/kim/kim_license.txt
cp ABOUT $kdeinstdir/share/kim/kim_about.txt

mkdir -p $kdeinstdir/share/kim/slideshow/
cp src/slideshow/* $kdeinstdir/share/kim/slideshow/

mkdir -p $kdeinstdir/share/kim/gallery
cp src/gallery/* $kdeinstdir/share/kim/gallery
chmod a+rx -R $kdeinstdir/share/kim

echo "Kim has been installed. Good bye!"
