<table align="center"><tr><td>
  <h2 align="center">⚠️&ensp;WARNING&ensp;⚠️</h2>
  <h3 align="center">This project is no longer maintained!</h3>
  <p>I have decided to end the project for the time being to work on other projects. However, the project is still usable, I just won't be developing it anymore.</p>
  <p>When there is time, I may return to the project, for now the repository is archived.</p>
  <p>If you want to get regular updates, switch to <a href="https://github.com/Prince781/valdo">Valdo CLI</a>.</p>
</td></tr></table>



<img align="left" alt="Icon" src="https://raw.githubusercontent.com/pervoj/valdo-gtk/master/data/icons/hicolor/scalable/apps/cz.pervoj.valdo-gtk.svg" height="170px">

# Valdo GTK

GTK frontend for [Valdo](https://github.com/Prince781/valdo)

[![Flatpak Workflow Status](https://img.shields.io/github/workflow/status/pervoj/valdo-gtk/Flatpak)](https://github.com/pervoj/valdo-gtk/actions?query=workflow:Flatpak)

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
meson compile -C build
build/valdo-gtk
```
