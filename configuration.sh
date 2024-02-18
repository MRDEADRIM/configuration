#!/bin/sh
date_time () {
	date +"%y-%b-%d %H:%M %p"
}

battery_percentage () {
	cat /sys/class/power_supply/BAT0/capacity
}
battery_status (){
	cat /sys/class/power_supply/BAT0/status
}
menu () {
	while true; do
		current_battery=$(battery_percentage)
		battery_status=$(battery_status)


		if [ "$battery_status" = "Charging" ]; then
			xsetroot -name "$(date_time) $current_battery% C"
		fi

		if [ "$battery_status" = "Discharging" ]; then
			if [ "$current_battery" -lt 5 ]; then
				shutdown now
			elif [ "$current_battery" -lt 10 ]; then
				xsetroot -name "Critical Status"
			elif [ "$current_battery" -lt 30 ]; then
				xsetroot -name "Low Power"
			else
				xsetroot -name "$(date_time) $current_battery%"
			fi
		fi

		sleep $((60 - $(date +%S) % 60))
	done
}

menu
