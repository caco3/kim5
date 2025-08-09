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

src_folder="$(dirname "$(realpath "$0")")"
kim_install_dir=`qtpaths --locate-dirs GenericDataLocation kio/servicemenus | cut -f 1 -d ':'`
kim_helper_files=$kim_install_dir/kim6

if [[ $? != 0 ]]; then
    "Error fetching the KDE install prefix. Exiting..."
    exit 1
fi

mkdir -p $kim_helper_files
cp -pr $src_folder/src/gallery $src_folder/src/po $src_folder/src/bin $src_folder/src/kim_translation $src_folder/ABOUT $src_folder/COPYING $kim_helper_files/
cp -pr $src_folder/src/kim_*.desktop $kim_install_dir

# Replace the path in Desktop files with the installed path
for file in $kim_install_dir/kim_*.desktop; do
  sed -i "s|Exec=kim|Exec=$kim_helper_files/bin/kim|g" "$file"
done

for file in $kim_helper_files/bin/kim_*; do
  sed -i "s|SOURCE_TRANSLATION_TTT|. $kim_helper_files/kim_translation|g" "$file"
  sed -i "s|KIM_INST_TTT|\$kim_inst=$kim_helper_files|g" "$file"
  sed -i "s|LOCALE_SOURCE_TTT|$kim_helper_files/locale|g" "$file"
done

# install translation mo files
for i in $kim_helper_files/po/*.po; do
	TRANSLANG=`basename -s .po $i`
	mkdir -p $kim_helper_files/locale/$TRANSLANG/LC_MESSAGES
	msgfmt -o $kim_helper_files/locale/$TRANSLANG/LC_MESSAGES/kim6.mo $i
done

echo "Kim has been installed. Good bye!"
