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
#
install_log=""

# If there is no kdedialog, create an error log and abort.
if [ ! `command -v kdialog` ]; then
    touch ~/kim6_installation_failed.log
	echo "You tried to install KDE Image Menu 6 (KIM 6) service menu for KDE's Dolphin file manager in an environment that does not have kdialog. Most of the functionality would not work and the installation was aborted. Please install KDE or kdialog and try again. This message was created by this command: $(realpath "$0")." > ~/kim6_installation_failed.log
    exit
fi

#function to show install errors
spit_install_log() {
kdialog --title "KIM 6 Installation problems" --error="$install_log"
}

if [ ! `command -v qtpaths` ]; then
	install_log="$install_log""KDE Image Menu 6 is meant to be run under KDE 6, but I can't find executable \"qtpaths\" that should be a part of your QT installation. Without qtpaths, I cannot check for installations directories.  Please check your system installation. Installation was aborted."
	spit_install_log
	exit 1
fi

if [ ! `command -v montage` ]; then
	install_log="$install_log""Cannot find executable \"montage\".  Please install it. It may be in package \"graphicsmagick\". Without it, the montage feature will not work.\n\n"
fi

if [ ! `command -v mogrify` ]; then
	install_log="$install_log""Cannot find executable \"mogrify\".  Please install it. It may be in package \"graphicsmagick\". Without it, a lot of features like resizing and rotating and other transformations will not work.\n\n"
fi

if [ ! `command -v convert` ]; then
	install_log="$install_log""Cannot find executable \"convert\".  Please install it. Without it, format conversion will not work.\n\n"
fi

# this will be removed, it relies on screen capturing thrugh X
#elif [ ! `command -v xwd` ]; then
#	install_log="$install_log""'\nCannot find executable \"xwd\".  Please install it."
#	exit

if [ ! `command -v ffmpeg` ]; then
	install_log="$install_log""Cannot find executable \"ffmpeg\".  Please install it. It may be in package \"ffmpeg\". Without it, video resizing will not work.\n\n"
fi

if [ ! `command -v xdg-email` ]; then
	install_log="$install_log""Cannot find executable \"xdg-email\".  Please install it. It may be in package \"xdg-utils\". Without it, sending an image by e-mail will not work.\n\n"
fi



src_folder="$(dirname "$(realpath "$0")")"
kim_install_dir=`qtpaths --locate-dirs GenericDataLocation kio/servicemenus | cut -f 1 -d ':'`
# This checks if qtpaths returned an existing directory
if [[ ! -d $kim_install_dir ]]; then
    install_log="$install_log""Error fetching the KDE install prefix. Installation was aborted."
	spit_install_log
    exit 1
fi
kim_helper_files=$kim_install_dir/kim6

# first uninstall so we do not leave anything behind when potentially renaming removing or moving stuff from version to version
$src_folder/uninstall.sh --no_message

mkdir -p $kim_helper_files
cp -pr $src_folder/src/gallery $src_folder/src/po $src_folder/src/bin $src_folder/src/kim_translation $src_folder/ABOUT $src_folder/COPYING $kim_helper_files/
cp -pr $src_folder/src/kim_*.desktop $kim_install_dir

# Replace the path in Desktop files with the installed path
for file in $kim_install_dir/kim_*.desktop; do
  sed -i "s|Exec=kim|Exec=$kim_helper_files/bin/kim|g" "$file"
done

for file in $kim_helper_files/bin/kim_*; do
  sed -i "s|SOURCE_TRANSLATION_TTT|. $kim_helper_files/kim_translation|g" "$file"
  sed -i "s|KIM_INST_TTT|kim_inst=$kim_helper_files|g" "$file"
  sed -i "s|LOCALE_SOURCE_TTT|$kim_helper_files/locale|g" "$file"
done

# install translation mo files
for i in $kim_helper_files/po/*.po; do
	TRANSLANG=`basename -s .po $i`
	mkdir -p $kim_helper_files/locale/$TRANSLANG/LC_MESSAGES
	msgfmt -o $kim_helper_files/locale/$TRANSLANG/LC_MESSAGES/kim6.mo $i
done

if [[ "$install_log" == "" ]]; then
	echo "Kim has been i succesfully installed. Good bye!"
else
	spit_install_log
fi
