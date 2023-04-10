
function date_time {
	date +"%y-%b-%d %H:%M %T %p"
}
function battery_percentage {
	cat /sys/class/power_supply/BAT0/capacity
}

function menu {
	while true; do
		xsetroot -name "$(date_time) $(battery_percentage)"
		sleep 1 
	done
}

menu
