while : ; do
    while ! lsusb | grep -i huawei;
    do
        echo "no huawei devices found"
        sleep 1s
    done
    echo sleep 5s
    sleep 5s
    echo generic_huawei_modeswitch
    /home/pi/diagnostic_box_scripts/field/cellular/generic_huawei_modeswitch
    echo sleep 5s
    sleep 5s
    echo sudo wvdial E397
    sudo wvdial E397
    echo sudo wvdial E531
    sudo wvdial E3531
done
