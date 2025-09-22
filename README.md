# Images Service menu for Dolphin (Plasma 6)

This is a basic port of KIM5 for Plasma 6. KIM itself apparently goes as far back as KDE3, at least.

Note that some actions in the treatment and publication menu do not work. Patches to either make them work or remove them altogether are welcome.

Here is the KDE store link: https://store.kde.org/p/2307290/

![Screenshot](KIM6.png)

## Dependencies
- Dolphin, KDialog and QT.
- ImageMagick.
- FFmpeg is used for video conversion (image manipulation will work without it).
- xdg-email for sending pictures by e-mail, which is usually in `xdg-utils` (Everything but sending by e-mail will work.)

## Install

1. The best way is to download directly from Doplhin's settings. Note that you might need to select different sorting for KIM6 to appear due to this bug: https://bugs.kde.org/show_bug.cgi?id=508140 

2. Another way is to download the latest release as a tar.gz file from https://github.com/felagund/kim6/releases.
   Then run:
```
servicemenuinstaller install ./kim6*.tar.gz
```
3. You can also clone the project using git or untar the downloaded archive and run the install manually:
```
cd kim/
./install.sh
```

## Uninstall
Best do it the same way you installed it.
1. Best done through Dolphin, though the uninstall might have to be done twice due to a bug: https://bugs.kde.org/show_bug.cgi?id=508142
2. Alternatively  locate the archive from which you installed. Dolphin saves the archives into '~/.local/share/servicemenu-download', if you installed manually, it does not get saved there. Then run:
```
servicemenuinstaller uninstall PATH_TO_INSTALL_ARCHIVE.tar.gz 
```

3. You can also run the uninstall script manually. Locate it and run:
```
./uninstall.sh
```
## Translations
To submit a new translation, just copy `kim6.pot` file into `lg.po` (replace "lg" with the shortcut of your language) and translate the strings there. Then open an issue here with the resulting file as an attachment to submit it. To test your translation, run dolphin like this (replace your new language, this is for Dutch):
```
LANGUAGE=nl LC_ALL=nl_NL.UTF-8 dolphin
```

To generate new `.pot` template and update the individual translations, one runs this in `kim/src/po` directory:
```
xgettext --language=Shell --keyword=gettext --output=kim6.pot --from-code=UTF-8 --add-comments=TRANSLATORS --package-name="KIM 6 – Kde Image Menu 6" --package-version="1.1" --msgid-bugs-address="https://github.com/felagund/kim6/issues" ../bin/kim_*
for po in *.po; do msgmerge --update "$po" kim6.pot; done
```
## Developement and release
Cloning from git will download a directory that contains this readme, a license file, a screenshot used in this readme and a kim directory where everything important is. After doing your changes, the easiest way to test them is to run in this high lever directory this:
```
tar -czf kim6_devel.tar.gz ./kim/*
servicemenuinstaller install kim6_devel.tar.gz
```
Then clean up with:
```
servicemenuinstaller install kim6_devel.tar.gz
```
## Todo
- Update manual (pointing to old site etc.)
- Display old and new sizes of resized files
- Fix desktop files so they are translated in po files
- Add new resolutions to resize plugins
- Add more options to video transformations
