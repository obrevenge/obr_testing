#!/bin/bash

title="Nemesis Installer"

yad --plug=12346 --tabnum=1 --text="<big>Welcome to the Nemesis Installer</big>\nThank you for Choosing a Revenge OS System" --form --field=" ":LBL --image="obr-logo-sm.png" --image-on-top --field="Click on the Next Tab to Get Started":LBL > /dev/null &

                                                   
yad --plug=12346 --tabnum=2 --text="Partitions" --text="<big>Partitioning</big>\n\nHow Would You Like to Partition Your Disk?\nAuto Partitioning will delete everything\non the disk and install Revenge OS\n\nManual Partitioning will allow you\nto create and edit partitions and choose where\nto install Revenge OS" --image="obr-logo-sm.png" --image-on-top --radiolist --list --column="Select" --column="Type" false "Automatic Partioning" false "Manual Partitioning" --separator=" " > answer.txt &    


yad --width=600 --height=500 --title="$title" --notebook --key=12346 --tab="Welcome" --tab="Tab 2"

part=` cat answer.txt | awk '{print $2;}' `

echo "The choice is $part"
