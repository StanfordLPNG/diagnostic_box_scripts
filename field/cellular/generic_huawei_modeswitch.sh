for PROD_ID in `lsusb | grep -i huawei | cut -d: -f 3- | cut -b 1-4`;
do
    echo "Trying to modeswitch from prod_id $PROD_ID"
    sudo /usr/sbin/usb_modeswitch -v 0x12d1 -p 0x$PROD_ID -W -R -M 55534243123456780000000000000011062000000100010100000000000000
done
