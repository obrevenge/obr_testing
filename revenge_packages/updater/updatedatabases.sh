#!/usr/bin/env bash

(pacman -Syy) | zenity --progress --title="Updater"  --text "Updating Databases" --no-cancel --pulsate --auto-close --width=500
