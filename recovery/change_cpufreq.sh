#!/bin/sh
HARDWARE=`cat /proc/cpuinfo | grep Hardware`
N2PLUS="N2Plus"

if [ -z "${HARDWARE##*$N2PLUS*}" ]
then
    sed -i s/_big=\"1800\"/_big=\"2208\"/g /sdcard/env.ini;
    sed -i s/_little=\"1896\"/_little=\"1908\"/g /sdcard/env.ini;
fi
