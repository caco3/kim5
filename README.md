# KDE Image Menu 6 — KIM6
KIM6 is a service menu for the KDE Plasma desktop. It adds context-menu actions in Dolphin and Folder View so you can resize, convert and batch-process images (and some video formats) directly from the file manager.

KDE store link: [KDE Store](https://store.kde.org/p/2307290/)

The manual: [KIM6 manual](https://kim-6.github.io/kim6/)

![Screenshot](KIM6.png)

## Features

* Process images directly from Dolphin's context menu.
* Compress and resize images for web, sharing or archival.
* Convert between multiple image formats.
* Rotate, flip and losslessly manipulate images.
* Sort images based on EXIF date.
* Batch-rename images with flexible patterns.
* Create HTML galleries, collages and simple GIF animations.
* Reduce or re-encode video clips using FFmpeg (HD or Full HD).

## Dependencies

- **KDE Plasma 6**: Dolphin, KDialog and Qt.
- **ImageMagick**: Required for most image operations.
- **FFmpeg**: Required for video conversion; image functions work without it.
- **xdg-email** from `xdg-utils`: Required for the “send by e-mail” action.

## Install

### Option 1: Install from Dolphin (recommended)

1. Open: Dolphin → Settings → Configure Dolphin → Services.
2. Search for “KIM6” and install it.
3. If it does not appear, try changing the sorting order in Dolphin's service list, which will refresh the view.

### Option 2: Install using `servicemenuinstaller` with a downloaded release

1. Download the latest `kim6_*.tar.gz` release from the project’s Releases page.
2. Install it using:

```
servicemenuinstaller install ./kim6_*.tar.gz
```

### Option 3: Install from a cloned repository
```
git clone https://github.com/KIM-6/kim6.git
cd kim6
./install.sh
```

## Uninstall

### Option 1: Remove from Dolphin

Use Dolphin’s service menu configuration to remove KIM6.  
On some systems, uninstall may need to be triggered twice because the service list does not always refresh correctly.

### Option 2: Remove using `servicemenuinstaller`

If you installed KIM6 using a `.tar.gz` archive:

1. Locate the archive. Dolphin usually stores downloaded service menu archives under:
```
~/.local/share/servicemenu-download
```
2. Uninstall with:
```
servicemenuinstaller uninstall PATH_TO_ARCHIVE.tar.gz
```
### Option 3: Remove from a cloned repository

From inside the cloned repository:
```
./uninstall.sh
```

## Usage

1. Select one or more images in Dolphin or Folder View.
2. Right-click and open the **KIM6** submenu.
3. Choose an action, such as “Compress and resize → Webexport 1920 px”.
4. Confirm whether to overwrite originals or create new files.

You can also run individual scripts directly:

```
./kim_resize ~/example.jpg 300x300
```

## History

- KIM6 is a fork for KDE 6 of KIM5: [KIM5 fork](https://github.com/caco3/kim5)
- One KDE4 fork is here: [KDE4 fork](https://store.kde.org/p/998188/)
- The original version for KDE4 is here: [Original KDE4 version](https://store.kde.org/p/1126887/)
- KIM itself goes as far back as KDE 3. There is a website that was still functioning in 2025: [KDE3](http://bouveyron.free.fr/kim/index.html)
- A huge majority of the code is from the original authors, thanks to them!

## See also
There is a functionally similar but independent project: [kde-service-menu-reimage](https://github.com/irfanhakim-as/kde-service-menu-reimage)

## Developer and translator information

### Translations
To submit a new translation, just run `msginit -l XX` in the po directory (replace "XX" with the shortcut of your language) and translate the strings there. Then open an issue here with the resulting file as an attachment to submit it or better create a pull request. Current wrong or incomplete translations can be done by directly editing the po files and opening pull requests.

To test your translation, install it (see release) and run Dolphin like this (replace your new language, this is for Dutch):
```
LANGUAGE=nl dolphin
```

To generate new `.pot` template and update the individual translations, one runs this in the project root directory (it actually runs in the `po` directory; unless you develop a new feature, you should not need this as I try to keep the translation strings up-to-date):
```
VERSION=2.1; # set kim6 version
cd po;
# this creates a new pot file from the files in the bin directory (do not update because then deleted strings are kept)
xgettext --language=Shell --keyword=gettext --output=kim6.pot --from-code=UTF-8 --add-comments=TRANSLATORS --package-name="KIM 6 — Kde Image Menu 6" --package-version="$VERSION" --msgid-bugs-address="https://github.com/KIM-6/kim6/issues" ../src/bin/kim_*

# this gets strings from the desktop.in files, one needs to first extract the strings before gettext can recognize them, that creates header files and so comments about string locations are then wrong in the po and pot files
for desk_ini in ../src/*.desktop.in;
do intltool-extract --type=gettext/ini "$desk_ini";
xgettext --keyword=N_:1 --join-existing --output kim6.pot --from-code=UTF-8 --package-name="KIM 6 — Kde Image Menu 6" --package-version="$VERSION" --msgid-bugs-address="https://github.com/KIM-6/kim6/issues" "$desk_ini".h;

# the header files are just temporary
rm "$desk_ini".h;
done;

# % in the strings causes gettext to include this warning that we get rid of
grep -v '^#, no-c-format' kim6.pot > temp.pot;
mv temp.pot kim6.pot;

# with the resulting pot file, we can update the po files in case there are new strings or some got deleted
for po in *.po; do msgmerge --update "$po" kim6.pot;
done
cd ..
```
## Release

Do not forget to update translations and changelog and then run the following (change VERSION) in the project root directory:
```
VERSION=2.0; # set kim6 version

# generate desktop files
cd po;
for desk_ini in ../src/*.desktop.in; do intltool-merge --desktop-style ./ "$desk_ini"  "${desk_ini%.in}"; chmod +x "${desk_ini%.in}" ; done
cd ..;

# Do not include files that need not be installed (we first need to create the archive so tar does not complain about file being changed as it is read)
touch kim6_$VERSION.tar.gz
tar -czf kim6_$VERSION.tar.gz --exclude=README.md  --exclude=KIM6.png --exclude=Changelog --exclude kim6_$VERSION.tar.gz --exclude kim6_*.tar.gz --exclude './src/*desktop.in' --exclude ./.* ./

# generated desktop files are no longer needed
rm src/kim_compressandresize.desktop src/kim_compressandresizevideo.desktop src/kim_convertandrotate.desktop src/kim_publication.desktop
```

After making the archive, it is manually uploaded here to Github and then to [Store](https://store.kde.org/p/2307290/)

## Development

Try to make a release (see above) and then test your changes with:
```
servicemenuinstaller install kim6_$VERSION.tar.gz
```
Then clean up with:
```
servicemenuinstaller uninstall kim6_$VERSION.tar.gz
```

It is also possible to run the `.install.sh` and `.uninstall.sh` scripts, the desktop files will be generated automatically. 

Individual scripts can also be run directly. Look into the bin files (which are bash scripts) to see what arguments they need. For example this resizes proportionally a given file 300 pixels along its shorter side:
```
./kim_resize ~/example.jpg 300x300
```

## Todo

- Functionally, KIM 6 is stable. Please report bugs if you find any.
- Technically, it would be good to merge executable files and refactor common code in functions, that should reduce the code size by half. Patches welcome!
