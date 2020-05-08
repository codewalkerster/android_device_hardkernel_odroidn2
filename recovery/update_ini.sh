#!/sbin/sh
Keys="hdmimode voutmode display_autodetect backlight_pwm zoom_rate colorattribute osd_reverse video_reverse suspend_hdmiphy cvbsmode disablehpd disable_vu7 touch_invert_x touch_invert_y test_mt_vid test_mt_pid max_freq_a73 max_freq_53 governor_a73 governor_a53 enable_wol heartbeat sg_tablesize adjustScreenWay screenAlignment"

TARGET="/odm/env.ini"
SEDCOMMAND="/odm/.sedcommand"

#should three argus, $1 - boot.ini, $2 - env.ini, $3 applied ini file.
if [[ -f "$TARGET" ]]; then
	# using env.ini, $2
	while IFS='=' read KEY VALUE ETC
	do
		if [[ "$Keys" == *"$KEY"* ]]; then
			command echo "s/^$KEY=\".*\"/$KEY=$VALUE/" >> $SEDCOMMAND
		fi
	done < $2
else
	# using boot.ini, $1
	while read SET KEY VALUE ETC
	do
		if [[ "$SET" == "setenv" ]]; then
			if [[ "$Keys" == *"$KEY"* ]]; then
				command echo "s/^$KEY=\".*\"/$KEY=$VALUE/" >> $SEDCOMMAND
			fi
		fi
	done < $1
fi

# apply patch to .env.ini.update, $3
sed -i -f $SEDCOMMAND $3

rm $SEDCOMMAND
