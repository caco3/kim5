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

if [ ! `command -v qtpaths` ]; then
	echo "KDE Image Menu is running under KDE 6, but I can't find executable \"qtpaths\".  Please check your system installation."
	exit
elif [ ! `command -v montage` ]; then
	echo "Can not find executable \"montage\".  Please install it. It may be in package \"graphicsmagick\"."
	exit
elif [ ! `command -v mogrify` ]; then
	echo "Can not find executable \"mogrify\".  Please install it. It may be in package \"graphicsmagick\"."
	exit
elif [ ! `command -v convert` ]; then
	echo "Can not find executable \"convert\".  Please install it."
	exit
elif [ ! `command -v xwd` ]; then
	echo "Can not find executable \"xwd\".  Please install it."
	exit
elif [ ! `command -v ffmpeg` ]; then
	echo "Can not find executable \"ffmpeg\".  Please install it. It may be in package \"ffmpeg\"."
	exit
elif [ ! `command -v xdg-email` ]; then
	echo "Can not find executable \"xdg-email\".  Please install it. It may be in package \"xdg-utils\"."
	exit
fi


kdeinstdir=`qtpaths --install-prefix`

if [[ $? != 0 ]]; then
    "Error fetching the KDE install prefix. Exiting..."
    exit 1
fi

cp -f src/kim_*.desktop $kdeinstdir/share/kio/servicemenus/
cp -f src/bin/kim_* $kdeinstdir/bin/
chmod a+r $kdeinstdir/share/kio/servicemenus/kim_*.desktop
chmod a+rx $kdeinstdir/bin/kim_*

mkdir -p $kdeinstdir/share/kim
cp COPYING $kdeinstdir/share/kim/kim_license.txt
cp ABOUT $kdeinstdir/share/kim/kim_about.txt
cp src/kim_translation $kdeinstdir/share/kim
chmod a+rx $kdeinstdir/bin/kim_*

mkdir -p $kdeinstdir/share/kim/gallery
cp src/gallery/* $kdeinstdir/share/kim/gallery
chmod a+rx -R $kdeinstdir/share/kim

# install translation mo files
for i in src/po/*.po; do
	MOFILE=/usr/share/locale/`basename -s .po $i`/LC_MESSAGES/kim6.mo
	msgfmt -o ${MOFILE} $i
done

echo "Kim has been installed. Good bye!"
