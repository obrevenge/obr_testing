#!/usr/bin/env bash

updates=` checkupdates `

if [[ $(echo $updates) == "" ]]
	then update="System Up To Date"
else
	update="$updates"
fi

zenity --info --title="Update Tool" --text "Available Updates:\n$update" --height=100
