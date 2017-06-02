#!/bin/bash

title="Nemesis Installer"

yad --plug=12347 --tabnum=1 --text="<big>Welcome to the Nemesis Installer</big>\nThank you for Choosing a Revenge OS System" --form --field=" ":LBL --image="obr-logo-sm.png" --image-on-top --field="Click on the Next Tab to Get Started":LBL > /dev/null &

                                                   
yad --plug=12347 --tabnum=2 --text="Partitions" --text="<big>Partitioning</big>\n\nHow Would You Like to Partition Your Disk?\nAuto Partitioning will delete everything\non the disk and install Revenge OS\n\nManual Partitioning will allow you\nto create and edit partitions and choose where\nto install Revenge OS" --image="obr-logo-sm.png" --image-on-top --radiolist --list --column="Select" --column="Type" false "Automatic Partioning" false "Manual Partitioning" --separator=" " > answer.txt &    


yad --width=600 --height=500 --title="$title" --notebook --key=12347 --tab="Welcome" --tab="Partitioning"

part=` cat answer.txt | awk '{print $2;}' `

if [ "$part" == "Manual" ]
	then gparted
    partitions=` find /dev -mindepth 1 -maxdepth 1  -name "*[sh]d[a-z][0-9]"  | sort | xargs -0 `
    fields=$(for i in $(echo $partitions)
        do
            echo "--field=${i}:CB"
        done)
        mounts=$(yad --width=600 --height=500 --title="$title" --text="What Partitions Do You Want to Use?\nSelect a Mount Point for Each Partition that You want to Use." --image="obr-logo-sm.png" --separator=" " --form $fields \
        "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media" "NA!/boot!/!/home!/var!/data!/media")
        
        rm mounts.txt
        for m in $(echo $mounts)
            do
                num="1"
                echo "/mnt$m" >> mounts.txt
                num="$num + 1"
            done
        
        rm mountpoints.txt
        for i in $(echo $partitions)
            do
                line=$(head -n 1 mounts.txt)
                echo "mount $i $line \n" >> mountpoints.txt
                tail -n +2 mounts.txt > mounts.txt.tmp && mv mounts.txt.tmp mounts.txt
            done
        
        mountpoints=$(cat mountpoints.txt)
        echo $mountpoints

fi

