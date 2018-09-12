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

kdeinstdir=`kde4-config --prefix`

cp src/kim_*.desktop $kdeinstdir/share/kde4/services/ServiceMenus/
cp src/bin/kim_* $kdeinstdir/bin/
chmod a+rx $kdeinstdir/bin/kim_*
chmod a+r $kdeinstdir/share/kde4/services/ServiceMenus/kim_*.desktop
mv $kdeinstdir/share/kde4/services/ServiceMenus/imageconverter.desktop $kdeinstdir/share/kde4/services/ServiceMenus/imageconverter.desktop~

mkdir $kdeinstdir/share/kim
cp COPYING $kdeinstdir/share/kim/kim_about.txt

mkdir $kdeinstdir/share/kim/slideshow/
cp src/slideshow/* $kdeinstdir/share/kim/slideshow/

mkdir $kdeinstdir/share/kim/gallery
cp src/gallery/* $kdeinstdir/share/kim/gallery

echo "Kim has been installed. Good bye!"