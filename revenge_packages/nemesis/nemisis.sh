#!/bin/bash

rm nemesis.conf
rm mountpoints
rm mounts
rm config1.txt
rm config2.txt
rm .passwd

title="Nemesis Installer"

greeting() {
    yad --width=600 --height=400 --center --title="$title" --image="crosshairs.png" --image-on-top --form --field=" ":LBL --image-on-top --field="<big>Welcome to the Nemesis Installer</big>\n\nThank you for Choosing a Revenge OS System. Click Okay to Get Started":LBL > answer.txt

    answer=` cat answer.txt `

    if [ "$answer" = "" ]
        then exit
    fi
}
                                                   
partitions() {
    yad --width=600 --height=400 --center --title="$title" --text="Partitions" --text="<big>Partitioning</big>\n\nHow Would You Like to Partition Your Disk? Auto Partitioning will delete everything on the disk and install Revenge OS\n\nManual Partitioning will allow you to create and edit partitions and choose where to install Revenge OS" --image="$logo" --radiolist --list --column="Select" --column="Type" false "Automatic Partioning" false "Manual Partitioning" --separator=" " > answer.txt   

    part=` cat answer.txt | awk '{print $2;}' `

    if [ "$part" == "Manual" ]
        then echo "partition=\"manual\"" >> nemesis.conf
        gparted
        partitions=` find /dev -mindepth 1 -maxdepth 1  -name "*[sh]d[a-z][0-9]"  | sort | xargs -0 `
        fields=$(for i in $(echo $partitions)
            do
                echo "--field=${i}:CB"
            done)
            mounts=$(yad --width=600 --height=500 --title="$title" --text="What Partitions Do You Want to Use?\nSelect a Mount Point for Each Partition that You want to Use." --image="$logo" --separator=" " --form $fields \
            "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap" "NA!/boot!/!/home!/var!/data!/media!swap")
        
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
                    echo "mount $i $line" >> mountpoints
                    tail -n +2 mounts.txt > mounts.txt.tmp && mv mounts.txt.tmp mounts.txt
                done
        
            chmod +x mountpoints
        elif [ "$part" == "Automatic" ]
            then echo "partition=\"automatic\"" >> nemesis.conf
        

    fi
}

config1(){
    locales=$(cat /etc/locale.gen | grep -v "#  " | sed 's/#//g' | sed 's/ UTF-8//g' | grep .UTF-8 | sort | awk '{ printf "!""\0"$0"\0" }')

    zones=$(cat /usr/share/zoneinfo/zone.tab | awk '{print $3}' | grep "/" | sed "s/\/.*//g" | sort -ud | sort | awk '{ printf "!""\0"$0"\0" }')

    yad --width=600 --height=400 --center --title="$title" --image="$logo" --text "Configuration" --form --field="Select Your Keyboard Layout:":CB --field="Select Your locale:":CB --field="Select Your Region:":CB --separator=" " \
    "us!af!al!am!at!az!ba!bd!be!bg!br!bt!bw!by!ca!cd!ch!cm!cn!cz!de!dk!ee!es!et!eu!fi!fo!fr!gb!ge!gh!gn!gr!hr!hu!ie!il!in!iq!ir!is!it!jp!ke!kg!kh!kr!kz!la!lk!lt!lv!ma!md!me!mk!ml!mm!mn!mt!mv!ng!nl!no!np!pc!ph!pk!pl!pt!ro!rs!ru!se!si!sk!sn!sy!tg!th!tj!tm!tr!tw!tz!ua!uz!vn!za" "$locales" "$zones" > config1.txt

    key=` cat config1.txt | awk '{print $1;}' `
    locale=` cat config1.txt | awk '{print $2;}' `
    zone=` cat config1.txt | awk '{print $3;}' `

    echo "key=\"$key\"" >> nemesis.conf
    echo "locale=\"$locale\"" >> nemesis.conf
    echo "zone=\"$zone\"" >> nemesis.conf

    rm config1.txt
}

config2() {
    subzones=$(cat /usr/share/zoneinfo/zone.tab | awk '{print $3}' | grep "$zone/" | sed "s/$zone\///g" | sort -ud | sort | awk '{ printf "!""\0"$0"\0" }')

    yad --width=600 --height=400 --center --title="$title" --image="$logo" --text "Configuration" --form --field="Select your sub-zone:":CB --field="Use UTC or Local Time?":CB --field="Choose a hostname:" --field="Choose a username:" --field="Enter Your User Password:H" --field="Re-enter Your User Password:H" --separator=" " \
    "$subzones" "!UTC!Localtime" "" "" "" "" > config2.txt

    subzone=` cat config2.txt | awk '{print $1;}' `
    clock=` cat config2.txt | awk '{print $2;}' `
    hname=` cat config2.txt | awk '{print $3;}' `
    username=` cat config2.txt | awk '{print $4;}' `
    rtpasswd1=` cat config2.txt | awk '{print $5;}' `
    rtpasswd2=` cat config2.txt | awk '{print $6;}' `

    if [ "$rtpasswd1" != "$rtpasswd2" ]
            then zenity --error --title="$title" --text "The passwords did not match, please try again." --height=40
            config2
    fi

    echo "subzone=\"$subzone\"" >> nemesis.conf
    echo "clock=\"$clock\"" >> nemesis.conf
    echo "hname=\"$hname\"" >> nemesis.conf
    echo "username=\"$username\"" >> nemesis.conf
    echo -e "$rtpasswd1\n$rtpasswd2" > .passwd
}

desktop() {
    desktops=$(yad --width=600 --height=400 --center --title="$title" --text="Desktops" --text="<big>Desktops</big>\n\nWhich Revenge OS Desktop would you like to install?" --image="$logo" --radiolist --list --column="Select" --column="Desktop" false "OBR Openbox" false "Gnome" false "Plasma" false "XFCE" false "Mate" false "i3" --separator=" ")
    echo $desktops
    
    desktop=` echo $desktops | awk '{print $2;}' `
    
    echo "desktop=\"$desktop\"" >> nemesis.conf
    
}

confirm() {
    yad --width=600 --height=400 --center --info --title="$title" --image="$logo" --text="You have chosen the following:\n\n$part partitioning\n\nkeyboard layout: $key\n\nTimezone: $zone $subzone\n\nHostname: $hname\n\nUsername: $username\n\nClock configuration: $clock\n\nDesktop: $desktop"
    
}

logo="revenge_logo_sm.png"

greeting
partitions
config1
config2
desktop
confirm








