#!/bin/bash

zenity --title=Nemesis --question --text 'Auto Partitioning will delete the entire drive and install Revenge OS\nAre you sure you want to use Auto Partitioning?'

if [ "$?" == "1" ]
    then exit
else
    echo "partition=\"auto\"" >> nemesis.conf
fi 
