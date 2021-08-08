#!/bin/bash
xgettext -f po/POTFILES -o po/valdo-gtk.pot -cTranslators: --from-code=UTF-8
sed -i -e "s/Project-Id-Version: PACKAGE VERSION/Project-Id-Version: valdo-gtk/" po/valdo-gtk.pot
msgmerge -U po/*.po po/valdo-gtk.pot
