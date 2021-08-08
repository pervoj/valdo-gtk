<img align="left" alt="Icon" src="https://raw.githubusercontent.com/pervoj/valdo-gtk/master/data/icons/hicolor/scalable/apps/cz.pervoj.valdo-gtk.svg">

# Valdo GTK

GTK frontend for [Valdo](https://github.com/Prince781/valdo)

<p align="center"><img alt="Screenshot 1" src="https://raw.githubusercontent.com/pervoj/valdo-gtk/master/data/images/screenshot1.png"></p>

<p align="center"><a href="https://flathub.org/apps/details/cz.pervoj.valdo-gtk"><img height="80px" alt="Download on Flathub" src="https://flathub.org/assets/badges/flathub-badge-en.svg"></a></p>

## Installing

### Stable

The recommended way to install Valdo GTK is to install it as Flatpak from Flathub. Just follow [these instructions](https://flathub.org/apps/details/cz.pervoj.valdo-gtk).

### Development

Development builds are automatically generated with every change. You can download it from [GitHub Actions](https://github.com/pervoj/valdo-gtk/actions).

## Build instructions:

```sh
meson build
ninja -C build
build/valdo-gtk
```
