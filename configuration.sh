#!/bin/bash

date_time() {
	date +"%y-%b-%d %H:%M %p"
}

battery_percentage() {
	cat /sys/class/power_supply/BAT0/capacity
}

battery_status() {
	cat /sys/class/power_supply/BAT0/status
}

beep_alert() {
	frequency=$1
	status=$2
	while $status; do
		paplay beep.wav
		sleep $frequency
		if [ "$(battery_status)" = "Charging" ]; then
			status=false
		fi
	done
}

menu() {
	while true; do
		current_battery=$(battery_percentage)
		status=$(battery_status)

		if [ "$status" = "Charging" ]; then
			xsetroot -name "$(date_time) $current_battery% C"
		elif [ "$status" = "Discharging" ]; then
			if [ "$current_battery" -lt 5 ]; then
				shutdown now
			elif [ "$current_battery" -lt 15 ]; then
				xsetroot -name "Critical Status"
				beep_alert 5 true
			elif [ "$current_battery" -lt 30 ]; then
				xsetroot -name "Low Power"
				beep_alert 15 true
			else
				xsetroot -name "$(date_time) $current_battery%"
			fi
		fi

		sleep $((60 - $(date +%S) % 60))
	done
}

menu
