#! /bin/bash

# raspi-config -- expand disk space

echo "disabling wifi"
sudo su -c 'echo blacklist brcmfmac > /etc/modprobe.d/wlan-blacklist.conf'

echo "installing git screen autossh dialog"
sudo apt-get update
sudo apt-get install -y vim git screen autossh dialog w3m

# Set up my dotfiles, also changes keyboard layout to US
echo "setting up greg dotfiles"
cd ~
git clone https://github.com/greghill/DotFiles.git
cd DotFiles
./initialize.sh

# Set up my diagnostic box scripts
echo "getting diagnostic box scripts"
cd ~
git clone https://github.com/StanfordLPNG/diagnostic_box_scripts

cd diagnostic_box_scripts/field

dialog --yesno 'Download cellular connectivity software? (no if using wired etherenet only)' 5 80
# from https://bash.cyberciti.biz/guide/A_yes/no_dialog_box
response=$?
case $response in
    0) ./initialize_cellular_extras.sh;;
    1) echo "Not installed.";;
    255) echo "[ESC] key pressed. Extras not installed";;
esac

echo "changing timezone to Los Angeles"
sudo ./change_timezone.sh

echo "Adding cron jobs"
crontab cron_jobs

echo "Changing filesystem to be read-only on future boots"
sudo ./make_readonly_filesystem.sh

echo "Adding eth0:0 so can always ssh with local cable to 192.168.10.10"
sudo ./make_default_wired_interface.sh
# Change password from raspberry, requires user input
passwd pi
# Change hostname, requires user input
sudo ./change_hostname.sh

# make default ssh key that is command restricted and add to repo
cat /dev/zero | ssh-keygen -q -N ""
RESTRICTED_KEY="command=\"~/diagnostic_box_scripts/cloud/cloud_util.py $(cat /etc/hostname) \$SSH_ORIGINAL_COMMAND\", $(cat ~/.ssh/id_rsa.pub)"
echo $RESTRICTED_KEY >> authorized_keys
git add authorized_keys
git commit -m "adding command restricted key for $(cat /etc/hostname) for cloud servers to add to authorized_keys"
git push
cd ../cloud
cp authorized_keys ~/.ssh/authorized_keys
cp known_hosts ~/.ssh/known_hosts

echo "will reboot on enter into readonly filesystem"
read -t 90001
sudo reboot
