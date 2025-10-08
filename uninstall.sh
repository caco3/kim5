#!/bin/bash
#
# Uninstallation script.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Unknown
#          Tomáš Hnyk <tomashnyk@gmail.com>

kim_install_dir=`qtpaths --locate-dirs GenericDataLocation kio/servicemenus | cut -f 1 -d ':'`

rm -f $kim_install_dir/kim_*.desktop 2&> /dev/null
rm -rf $kim_install_dir/kim6 2&> /dev/null

if [[ "$1" == "--no_message" ]]; then
	: # Say nothing when called from install script
else
	echo "Kim6 has been removed. Good bye."
fi

