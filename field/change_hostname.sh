#! /bin/bash
if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

echo "enter new hostname"
read -t 90000 NEW_HOSTNAME
if [ $(echo -n $NEW_HOSTNAME | wc -w) -eq 1 ] && [ $(echo -n $NEW_HOSTNAME | wc -m) -gt 0 ] # check new hostname exactly one word with positive length
then
    sed -i "s/raspberrypi/$NEW_HOSTNAME/g" /etc/hosts /etc/hostname
    if [ $(cat /etc/hostname) == $NEW_HOSTNAME ]
    then
        echo hostname changed successfully to $NEW_HOSTNAME
    else
        echo hostname change failure
    fi
else
    echo invalid hostname: $NEW_HOSTNAME
fi
