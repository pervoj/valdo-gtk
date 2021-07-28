#!/bin/bash
xgettext -f po/POTFILES -o po/valdo-gtk.pot -cTranslators: --from-code=UTF-8
msgmerge -U po/*.po po/valdo-gtk.pot