#!/sbin/sh
Keys="hdmimode voutmode display_autodetect backlight_pwm zoom_rate colorattribute osd_reverse video_reverse suspend_hdmiphy cvbsmode disablehpd ignorecec disable_vu7 touch_invert_x touch_invert_y test_mt_vid test_mt_pid max_freq_a73 max_freq_53 governor_a73 governor_a53 enable_wol heartbeat sg_tablesize adjustScreenWay screenAlignment autoFramerate gpuScaleMode overlays overlay_resize gpiopower"

# Apply commands table
SEDCOMMAND="/odm/.sedcommand"

# $1 should be like a boot.ini format, $2 is like a env.ini format.
while read SET KEY VALUE ETC
do
	if [[ "$SET" == "setenv" ]]; then
		if [[ "$Keys" == *"$KEY"* ]]; then
			command echo "s/^$KEY=\".*\"/$KEY=$VALUE/" >> $SEDCOMMAND
		fi
	fi
done < $1

# apply patch to .env.ini.update, $2
sed -i -f $SEDCOMMAND $2

rm $SEDCOMMAND
