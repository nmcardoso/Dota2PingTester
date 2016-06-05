#!/bin/bash 

LOCALE=("Australia (Sydney)" "Chile (Santiago)" "Dubai (UAE)"
            "Europe East 1 (Viena, Austria)" "Europe East 2 (Vienna, Austria)"
            "Europe West 1 (Luxembourg)" "Europe West 2 (Luxembourg)"
            "India (Kolkata)" "Peru (Lima)" "Russia 1 (Stockholm, Sweden)"
            "Russia 2 (Stockholm, Sweden)" "SE Asia 1 (Singapore)"
            "SE Asia 2 (Singapore)" "South Africa 1 (Cape Town)"
            "South Africa 2 (Cape Town)" "South Africa 3 (Cape Town)"
            "South Africa 4 (Johannesburg)" "South America 1 (Sao Paulo)"
            "South America 2 (Sao Paulo)" "South America 3 (Sao Paulo)"
            "US East (Sterling, VA)" "US West (Seattle, WA)")

ADDRESS=("syd.valve.net" "200.73.67.1" "dxb.valve.net" "vie.valve.net"
            "185.25.182.1" "lux.valve.net" "146.66.158.1" "116.202.224.146"
            "191.98.144.1" "sto.valve.net" "185.25.180.1" "sgp-1.valve.net"
            "sgp-2.valve.net" "cpt-1.valve.net" "197.80.200.1" "197.84.209.1"
            "196.38.180.1" "gru.valve.net" "209.197.25.1" "209.197.29.1"
            "iad.valve.net" "eat.valve.net")

pingTest() {
	# $1: host name
	# Returns: average ping value
	ping_value=$(ping -c 3 $1 | awk '{print $4}' | tail -1 | cut -d '/' -f 2)
	echo "$ping_value"
}

menu() {
	clear
	
	default_item=${1-0} # if no param, set 0 to default
	
	menu_items=()
	for ((i = 0; i < ${#LOCALE[@]}; i++)) do
		menu_items+=("$i" "${LOCALE[$i]}")
	done
	
	option=$(whiptail --title "Dota 2 Ping Tester" --menu "Select a server to test" --default-item "$default_item" 15 60 6 "${menu_items[@]}" 3>&1 1>&2 2>&3)
	
	exit_status=$?
	if [ $exit_status -eq 1 ]; then
		echo "Goodbye..."
		exit 1
	fi
	
	echo "Chosen server: ${LOCALE[$option]} (${ADDRESS[$option]})"
	echo "Calculating ping..."
	
	avg_ping=$(pingTest ${ADDRESS[$option]})
	
	if [ "$avg_ping" = "" ]; then
		red=`tput setaf 1`
		bold=`tput bold`
		reset=`tput sgr0`
		echo "${red}${bold}Aborting:${reset} An error has occurred."
		exit 1
	fi
	
	whiptail --title "Result" --yesno "Average ping: $avg_ping ms\n\nRepeat Test?" 10 78
	
	exit_status=$?
	if [ $exit_status -eq 0 ]; then
		menu $option
	else
		echo "Goodbye..."
		exit 0
	fi
}

menu
