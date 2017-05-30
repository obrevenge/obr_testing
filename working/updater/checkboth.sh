#!/usr/bin/env bash

aur=` cower -u `
available=` checkupdates `


if [[ $(echo $available $aur) == "" ]]
	then update="System Up To Date"
else
	update="$updates"
fi


zenity --info --title="Update Tool" --text "Available Updates:\n$aur\n$available" --height=100